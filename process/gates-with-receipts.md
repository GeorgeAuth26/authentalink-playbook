# Gates With Receipts

**The player doesn't get to say he scored. The ref goes to the monitor.**

AI builders are good at writing "all green, done" at the end of a report. Sometimes it's true. Sometimes a check never ran, one was red, or the number came from memory. Gates with receipts make that impossible to fake: every sprint gets a scorecard, and only a script can check a box.

## How it works

1. **When the plan is approved, write the scorecard before any build code.** One file per sprint, named after its plan: `docs/prds/gates/<plan name>.md`. Start from [templates/gates-checklist.md](../templates/gates-checklist.md).
2. **One gate per acceptance criterion.** A gate is either:
   - **Runnable:** it has a `CHECK:` (a command) and an `EXPECT:` (text the command prints only when everything passed), or
   - **Manual:** no command. A person signs it: push, publish, the live smoke test.
3. **Run the referee:** `bash scripts/gates-check.sh docs/prds/gates/<plan name>.md`
   - It reruns **every** runnable gate, every time. Old receipts count for nothing.
   - A gate passes only if the command exits 0 **and** the EXPECT text shows up. A command that prints the right words and then fails is still a fail.
   - On a pass, it checks the box and stamps a receipt: time, commit, exit code, the matched line, and a fingerprint of the output. If the working tree had unsaved changes, the commit carries `+uncommitted`.
   - On a fail, it unchecks the box, resets the receipt to `pending`, and prints the full output.
   - It never touches manual gates.
   - Last line: `GATES: <n> met, <n> open, <n> manual open`. It exits 0 only when no runnable gate is open.
4. **The report pastes that output word for word.** No summary, no paraphrase.

## The rules

- **Nobody hand-types a receipt or checks a box on a runnable gate.** The builder can't, and you shouldn't either. A hand-typed receipt gets wiped on the next run anyway.
- **A gate must look at the actual thing:** the file, the endpoint, the database row, the rendered page. `echo ok` is not a gate.
- **Prove "nothing bad exists" checks can fail.** Plant a known bad sample, watch the gate go red, then remove it. Never commit the planted sample.
- **A check that can't run is not passed.** A timeout, a missing tool, or a server that's down means the box stays open, with the reason. It's never "skipped." The default time limit is 120 seconds; add `TIMEOUT: <seconds>` for a slow gate.
- **The final quality check goes last.** Mark the gate that runs your qa-gate with `LAST: yes`. It must be the last runnable gate, and it's skipped whenever anything before it is open. That way "all acceptance criteria verified: YES" is only ever said after everything before it actually passed.
- **YES means zero open.** qa-gate's `verified: YES` line may only be written when the checker shows 0 open runnable gates. Manual gates can still be open at commit time.
- **After a crash, read the scorecard first.** A new session runs the checker before doing anything else. The receipts are the state of the sprint, not anyone's memory or the last report.
- **Don't edit the scorecard in a hosting tool's editor.** Some auto-save every file touch as its own commit. Let the script and the builder be the only ones that touch it.

## Signing a manual gate

The founder does the thing, then writes the receipt (or tells the builder exactly what to write):

```
- [x] G5: pushed to origin/main (founder)
  RECEIPT: Founder push 2026-09-24 PASS (origin/main = 6c7b69f)
```

For a push, have the builder compare the local commit to the remote and include the hash. For publish and smoke, the founder's word is the receipt: `(attested by <name>)`.

## Why this exists

We had reports say "verified: YES" before the proofs had run, and one of them was red. We had a results table that looked finished after a crash. We had a "what goes live" line written from memory. Each time, the claim was confident and wrong. Receipts turn "trust me" into "check the scorecard."

## Credit

The idea and file format are adapted from [unlazy](https://github.com/Leonxlnx/unlazy) (MIT). We borrowed the idea, not the code: no approval system, no stop hook, no parallel runs. Just the scorecard and the referee.
