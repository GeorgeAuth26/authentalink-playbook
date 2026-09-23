# PASTE-INTO-CODE-[N]: [short name]

Confirm your plan before writing any files.

[If a prior paste may still be running:] Paste this only after PASTE [N-1] has reported. If it's still running, stop and say so.

## Rulings ([owner], [date])
<!-- Filled in before pasting. A blank ruling means its section is skipped. -->
- **[#].** [The question in one line.] **Answer:** ______
- **[#].** ______

## What this is (plain words)
[Two or three sentences: what we're doing, why, what it means for the customer.]

## S0. Read-only status (no writes)
1. Branch tips, worktrees, clean tree, anything unpushed.
2. Current baselines (type errors, pinned counts, test totals with the command).
3. Git log on the target files since the plan was written. Name any plan line that no longer matches the code.
4. [Any recon specific to this work.]

Stop and ask if recon contradicts the plan.

## S1. Rulings into the plan (docs commit first)
Write the rulings above into [PRD file] section 9, and task changes into section 10. Commit alone.

## S2 to S[n]. Tasks
One commit per task, each naming the plan and FR numbers. UI tasks name their board and end with side-by-sides at 375 and 1440.

**Stop points:** [where to stop and report instead of continuing].

## S[last]. Prove it
- Removal checks, red then green, with the count
- Full test suite with the command named; inherited failures only
- Baselines unchanged or better
- Switch-off proof if behind a switch
- Reviewers run where they apply
- Fixtures removed and counted, ports free, clean tree, push

## Report format (plain words for [owner])
What happened, commit hashes, the proofs, differences kept on purpose, questions numbered from Q[next], anything NOT RUN and why, and a dates line: does anything on the calendar move?

## Standing guards
No work beyond the plan. No destructive schema changes. No force-push. Never print env values. No em dashes on added lines. qa-gate on every commit. Clean tree at the end.
