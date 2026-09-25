#!/usr/bin/env bash
# gates-check.sh: the referee for a sprint's gates checklist.
#
# Usage: bash scripts/gates-check.sh <checklist.md>
#
# It reruns every runnable gate, every time. A gate passes only when its
# command exits 0 AND its EXPECT text appears in the output. Only this script
# checks a box or writes a receipt. Manual gates (no CHECK) are left alone:
# a person signs those.
#
# Exit codes: 0 = no runnable gate open; 1 = at least one open; 2 = bad usage
# or a malformed checklist (nothing is run and nothing is changed).
#
# See process/gates-with-receipts.md for the format and the rules.

set -u

DEFAULT_TIMEOUT=120

die() { echo "gates-check: $*" >&2; exit 2; }

[ $# -eq 1 ] || die "usage: bash scripts/gates-check.sh <checklist.md>"
FILE="$1"
[ -f "$FILE" ] || die "no such file: $FILE"

# ---------- tools ----------
if command -v sha256sum >/dev/null 2>&1; then
  hash_file() { sha256sum "$1" | cut -c1-12; }
elif command -v shasum >/dev/null 2>&1; then
  hash_file() { shasum -a 256 "$1" | cut -c1-12; }
else
  die "need sha256sum or shasum"
fi

commit_id() {
  local h
  h=$(git rev-parse --short HEAD 2>/dev/null) || { echo "no-git"; return; }
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "${h}+uncommitted"
  else
    echo "$h"
  fi
}

# Run $1 (a shell command) with a time limit of $2 seconds.
# Writes combined stdout+stderr to $3. Returns the command's exit code,
# or 124 on timeout.
run_with_timeout() {
  local cmd="$1" limit="$2" out="$3"
  if command -v timeout >/dev/null 2>&1; then
    timeout --kill-after=5 "$limit" bash -c "$cmd" >"$out" 2>&1
    return $?
  elif command -v gtimeout >/dev/null 2>&1; then
    gtimeout --kill-after=5 "$limit" bash -c "$cmd" >"$out" 2>&1
    return $?
  fi
  # Fallback without coreutils timeout (stock macOS).
  local flag rc pid watcher
  flag=$(mktemp)
  rm -f "$flag"
  bash -c "$cmd" >"$out" 2>&1 &
  pid=$!
  ( sleep "$limit"; if kill -0 "$pid" 2>/dev/null; then : >"$flag"; kill -TERM "$pid" 2>/dev/null; sleep 5; kill -KILL "$pid" 2>/dev/null; fi ) &
  watcher=$!
  wait "$pid"; rc=$?
  kill "$watcher" 2>/dev/null; wait "$watcher" 2>/dev/null
  if [ -e "$flag" ]; then rm -f "$flag"; return 124; fi
  return $rc
}

# ---------- parse ----------
mapfile -t LINES < "$FILE" 2>/dev/null || {
  # bash 3 (macOS) has no mapfile
  LINES=()
  while IFS= read -r l || [ -n "$l" ]; do LINES+=("$l"); done < "$FILE"
}

IDS=(); BOX_LINE=(); CHECK=(); EXPECT=(); TIMEOUT=(); LAST=(); RECEIPT_LINE=()
cur=-1
in_fence=0
for i in "${!LINES[@]}"; do
  line="${LINES[$i]}"
  if [[ "$line" =~ ^[[:space:]]*(\`\`\`|~~~) ]]; then
    in_fence=$((1 - in_fence)); continue
  fi
  [ $in_fence -eq 1 ] && continue
  if [[ "$line" =~ ^-\ \[([\ xX])\]\ ([A-Za-z0-9_.-]+):\ (.*)$ ]]; then
    id="${BASH_REMATCH[2]}"
    for seen in "${IDS[@]+"${IDS[@]}"}"; do
      [ "$seen" = "$id" ] && die "malformed: duplicate gate id $id"
    done
    cur=${#IDS[@]}
    IDS+=("$id"); BOX_LINE+=("$i"); CHECK+=(""); EXPECT+=(""); TIMEOUT+=("")
    LAST+=(""); RECEIPT_LINE+=("")
    continue
  fi
  [ $cur -lt 0 ] && continue
  if [[ "$line" =~ ^[[:space:]]+CHECK:\ (.*)$ ]]; then CHECK[$cur]="${BASH_REMATCH[1]}"
  elif [[ "$line" =~ ^[[:space:]]+EXPECT:\ (.*)$ ]]; then EXPECT[$cur]="${BASH_REMATCH[1]}"
  elif [[ "$line" =~ ^[[:space:]]+TIMEOUT:\ ([0-9]+)[[:space:]]*$ ]]; then TIMEOUT[$cur]="${BASH_REMATCH[1]}"
  elif [[ "$line" =~ ^[[:space:]]+LAST:\ yes[[:space:]]*$ ]]; then LAST[$cur]="yes"
  elif [[ "$line" =~ ^[[:space:]]+RECEIPT: ]]; then RECEIPT_LINE[$cur]="$i"
  fi
done

[ ${#IDS[@]} -gt 0 ] || die "malformed: no gates found"

last_runnable=-1
for g in "${!IDS[@]}"; do
  c="${CHECK[$g]}"; e="${EXPECT[$g]}"
  if [ -n "$c" ] && [ -z "$e" ]; then die "malformed: ${IDS[$g]} has CHECK but no EXPECT"; fi
  if [ -z "$c" ] && [ -n "$e" ]; then die "malformed: ${IDS[$g]} has EXPECT but no CHECK"; fi
  [ -n "${RECEIPT_LINE[$g]}" ] || die "malformed: ${IDS[$g]} has no RECEIPT line"
  [ -n "$c" ] && last_runnable=$g
  if [ -n "${LAST[$g]}" ] && [ -z "$c" ]; then die "malformed: ${IDS[$g]} is LAST but not runnable"; fi
done
for g in "${!IDS[@]}"; do
  if [ -n "${LAST[$g]}" ] && [ "$g" -ne "$last_runnable" ]; then
    die "malformed: ${IDS[$g]} is marked LAST but is not the last runnable gate"
  fi
done

# ---------- run ----------
COMMIT=$(commit_id)
echo "gates-check: $FILE (HEAD $COMMIT)"
OUT=$(mktemp)
trap 'rm -f "$OUT" "$FILE.gates-tmp"' EXIT

met=0; open=0; manual_open=0; earlier_open=0
set_box() {  # $1 gate index, $2 " " or "x"
  local bl="${BOX_LINE[$1]}"
  LINES[$bl]="${LINES[$bl]/#- \[?\]/- [$2]}"
}
set_receipt() {  # $1 gate index, $2 receipt text
  local rl="${RECEIPT_LINE[$1]}" indent
  indent="${LINES[$rl]%%RECEIPT:*}"
  LINES[$rl]="${indent}RECEIPT: $2"
}

for g in "${!IDS[@]}"; do
  id="${IDS[$g]}"; c="${CHECK[$g]}"; e="${EXPECT[$g]}"
  if [ -z "$c" ]; then
    box="${LINES[${BOX_LINE[$g]}]}"
    rec="${LINES[${RECEIPT_LINE[$g]}]#*RECEIPT: }"
    if [[ "$box" =~ ^-\ \[[xX]\] ]] && [ -n "$rec" ] && [ "$rec" != "pending" ]; then
      echo "$id manual: met ($rec)"; met=$((met + 1))
    else
      echo "$id manual: open (pending)"; manual_open=$((manual_open + 1))
    fi
    continue
  fi

  if [ -n "${LAST[$g]}" ] && [ $earlier_open -eq 1 ]; then
    echo "$id OPEN: not run: earlier gate open"
    set_box "$g" " "; set_receipt "$g" "pending"
    open=$((open + 1)); continue
  fi

  limit="${TIMEOUT[$g]:-$DEFAULT_TIMEOUT}"
  start=$(date +%s)
  run_with_timeout "$c" "$limit" "$OUT"; rc=$?
  secs=$(( $(date +%s) - start ))

  reason=""
  if [ $rc -eq 124 ]; then reason="timeout after ${limit}s"
  elif [ $rc -eq 127 ]; then reason="command not found (exit 127)"
  elif [ $rc -ne 0 ]; then reason="exit $rc"
  elif ! grep -qF -- "$e" "$OUT"; then reason="EXPECT text not found: $e"
  fi

  if [ -z "$reason" ]; then
    matched=$(grep -F -m1 -- "$e" "$OUT" | sed 's/^[[:space:]]*//; s/"/'"'"'/g')
    echo "$id MET (exit 0, ${secs}s): matched \"$matched\""
    set_box "$g" "x"
    set_receipt "$g" "$(date -u +%Y-%m-%dT%H:%M:%SZ) $COMMIT exit=0 matched=\"$matched\" sha256=$(hash_file "$OUT")"
    met=$((met + 1))
  else
    echo "$id OPEN: $reason"
    echo "  --- output of $id (exit $rc, ${secs}s) ---"
    sed 's/^/  /' "$OUT"
    echo "  --- end of $id ---"
    set_box "$g" " "; set_receipt "$g" "pending"
    open=$((open + 1)); earlier_open=1
  fi
done

# ---------- write back (atomic) ----------
printf '%s\n' "${LINES[@]}" > "$FILE.gates-tmp" && mv "$FILE.gates-tmp" "$FILE"

echo "GATES: $met met, $open open, $manual_open manual open"
[ $open -eq 0 ] && exit 0 || exit 1
