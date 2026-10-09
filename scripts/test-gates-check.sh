#!/usr/bin/env bash
# Tests for gates-check.sh. Each test is a trick play the referee must catch.
# Usage: bash scripts/test-gates-check.sh
# Last line on success: "gates-check tests: <n> passed, 0 failed"

set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
CHECKER="$HERE/gates-check.sh"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
mkdir "$WORK/repo" && cd "$WORK/repo" || exit 2
git init -q . && git -c user.email=t@t -c user.name=t commit -q --allow-empty -m init
OUTF="$WORK/out.txt"   # outside the repo, so it never makes the tree dirty

pass=0; fail=0
ok()  { echo "PASS $1"; pass=$((pass + 1)); }
bad() { echo "FAIL $1: $2"; fail=$((fail + 1)); }

run() { bash "$CHECKER" "$1" >"$OUTF" 2>&1; echo $?; }

write() { cat > g.md; }

# 1. A real pass checks the box and writes a receipt.
write <<'EOF'
# Gates: t
- [ ] G1: prints hello
  CHECK: echo hello-marker
  EXPECT: hello-marker
  RECEIPT: pending
EOF
rc=$(run g.md)
if [ "$rc" = 0 ] && grep -q '^- \[x\] G1' g.md && grep -q 'RECEIPT: .* exit=0 matched="hello-marker" sha256=' g.md; then
  ok "pass writes box and receipt"; else bad "pass writes box and receipt" "rc=$rc"; fi

# 2. Wrong EXPECT: box unchecked, receipt reset, exit 1.
write <<'EOF'
- [x] G1: prints hello
  CHECK: echo hello-marker
  EXPECT: goodbye-marker
  RECEIPT: 2026-01-01T00:00:00Z abc exit=0 matched="goodbye-marker" sha256=fake
EOF
rc=$(run g.md)
if [ "$rc" = 1 ] && grep -q '^- \[ \] G1' g.md && grep -q 'RECEIPT: pending' g.md && grep -q 'EXPECT text not found' "$OUTF"; then
  ok "wrong EXPECT fails and wipes a fake receipt"; else bad "wrong EXPECT" "rc=$rc"; fi

# 3. Nonzero exit fails even when the EXPECT text is printed.
write <<'EOF'
- [ ] G1: lies then fails
  CHECK: echo ok-marker; exit 3
  EXPECT: ok-marker
  RECEIPT: pending
EOF
rc=$(run g.md)
if [ "$rc" = 1 ] && grep -q 'exit 3' "$OUTF" && grep -q 'RECEIPT: pending' g.md; then
  ok "nonzero exit never passes"; else bad "nonzero exit" "rc=$rc"; fi

# 4. LAST gate is not run when an earlier gate is open.
write <<'EOF'
- [ ] G1: broken
  CHECK: false
  EXPECT: x
  RECEIPT: pending
- [x] G2: final check
  CHECK: touch ran-last && echo final-ok
  EXPECT: final-ok
  LAST: yes
  RECEIPT: 2026-01-01T00:00:00Z abc exit=0 matched="final-ok" sha256=old
EOF
rc=$(run g.md)
if [ "$rc" = 1 ] && [ ! -e ran-last ] && grep -q 'G2 OPEN: not run: earlier gate open' "$OUTF" && grep -q '^- \[ \] G2' g.md; then
  ok "LAST gate skipped after an earlier failure"; else bad "LAST skip" "rc=$rc"; fi

# 5. LAST gate runs when everything before it passed.
write <<'EOF'
- [ ] G1: fine
  CHECK: echo a-ok
  EXPECT: a-ok
  RECEIPT: pending
- [ ] G2: final check
  CHECK: echo final-ok
  EXPECT: final-ok
  LAST: yes
  RECEIPT: pending
EOF
rc=$(run g.md)
if [ "$rc" = 0 ] && grep -q '^- \[x\] G2' g.md; then ok "LAST gate runs after all pass"; else bad "LAST runs" "rc=$rc"; fi

# 6. Timeout counts as open, with the reason.
write <<'EOF'
- [ ] G1: hangs
  CHECK: sleep 10; echo done-marker
  EXPECT: done-marker
  TIMEOUT: 1
  RECEIPT: pending
EOF
start=$(date +%s); rc=$(run g.md); took=$(( $(date +%s) - start ))
if [ "$rc" = 1 ] && grep -q 'timeout after 1s' "$OUTF" && [ "$took" -lt 9 ]; then
  ok "timeout is open, not skipped"; else bad "timeout" "rc=$rc took=${took}s"; fi

# 7. Missing tool counts as open.
write <<'EOF'
- [ ] G1: missing tool
  CHECK: no-such-tool-xyz
  EXPECT: anything
  RECEIPT: pending
EOF
rc=$(run g.md)
if [ "$rc" = 1 ] && grep -q 'command not found' "$OUTF"; then ok "missing tool is open"; else bad "missing tool" "rc=$rc"; fi

# 8. Manual gates are never touched by the script.
write <<'EOF'
- [ ] G1: auto
  CHECK: echo auto-ok
  EXPECT: auto-ok
  RECEIPT: pending
- [x] G2: founder smoke
  RECEIPT: Founder smoke 2026-01-01 PASS
- [ ] G3: founder push
  RECEIPT: pending
EOF
before2=$(grep -A1 'G2:' g.md); before3=$(grep -A1 'G3:' g.md)
rc=$(run g.md)
if [ "$rc" = 0 ] && [ "$(grep -A1 'G2:' g.md)" = "$before2" ] && [ "$(grep -A1 'G3:' g.md)" = "$before3" ] \
   && grep -q 'GATES: 2 met, 0 open, 1 manual open' "$OUTF"; then
  ok "manual gates untouched and counted"; else bad "manual gates" "rc=$rc"; fi

# 9. A checked box with no real receipt on a manual gate is still open.
write <<'EOF'
- [x] G1: founder smoke
  RECEIPT: pending
EOF
rc=$(run g.md)
if grep -q 'G1 manual: open' "$OUTF"; then ok "checked box without receipt is not met"; else bad "manual fake box" "rc=$rc"; fi

# 10. The receipt names the commit, and flags uncommitted changes.
write <<'EOF'
- [ ] G1: prints
  CHECK: echo p-ok
  EXPECT: p-ok
  RECEIPT: pending
EOF
git add -A && git -c user.email=t@t -c user.name=t commit -q -m clean
head=$(git rev-parse --short HEAD)
run g.md >/dev/null
clean_ok=0; grep -q " $head exit=0" g.md && clean_ok=1
git checkout -q g.md; echo dirty > dirty.txt
run g.md >/dev/null
if [ $clean_ok = 1 ] && grep -q " ${head}+uncommitted exit=0" g.md; then
  ok "receipt names the commit and flags uncommitted changes"; else bad "commit in receipt" "clean_ok=$clean_ok"; fi
rm -f dirty.txt

# 11 to 15. Malformed files are refused with exit 2 and left unchanged.
malformed() {
  local name="$1"; cp g.md before.md
  rc=$(run g.md)
  if [ "$rc" = 2 ] && cmp -s g.md before.md && grep -q malformed "$OUTF"; then ok "refuses: $name"; else bad "refuses: $name" "rc=$rc"; fi
}
write <<'EOF'
- [ ] G1: half
  CHECK: echo x
  RECEIPT: pending
EOF
malformed "CHECK without EXPECT"
write <<'EOF'
- [ ] G1: a
  RECEIPT: pending
- [ ] G1: b
  RECEIPT: pending
EOF
malformed "duplicate id"
write <<'EOF'
# Gates: nothing here
EOF
malformed "zero gates"
write <<'EOF'
- [ ] G1: final
  CHECK: echo f
  EXPECT: f
  LAST: yes
  RECEIPT: pending
- [ ] G2: after final
  CHECK: echo g
  EXPECT: g
  RECEIPT: pending
EOF
malformed "LAST not last"
write <<'EOF'
- [ ] G1: no receipt line
  CHECK: echo x
  EXPECT: x
EOF
malformed "missing RECEIPT line"

# 16. Gates inside a fenced example are ignored.
write <<'EOF'
```
- [ ] G9: example only
  CHECK: false
  EXPECT: never
  RECEIPT: pending
```
- [ ] G1: real
  CHECK: echo real-ok
  EXPECT: real-ok
  RECEIPT: pending
EOF
rc=$(run g.md)
if [ "$rc" = 0 ] && ! grep -q 'G9' "$OUTF"; then ok "fenced examples ignored"; else bad "fence" "rc=$rc"; fi

# 17. Every run reruns a gate that was already met, and catches a regression.
write <<'EOF'
- [ ] G1: file exists
  CHECK: test -f thing.txt && echo thing-ok
  EXPECT: thing-ok
  RECEIPT: pending
EOF
touch thing.txt; run g.md >/dev/null
rm thing.txt; rc=$(run g.md)
if [ "$rc" = 1 ] && grep -q '^- \[ \] G1' g.md; then ok "met gate is rerun and can go back to open"; else bad "rerun" "rc=$rc"; fi

echo "gates-check tests: $pass passed, $fail failed"
[ $fail -eq 0 ]
