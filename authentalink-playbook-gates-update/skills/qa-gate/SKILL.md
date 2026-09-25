---
name: qa-gate
description: Mandatory pre-commit quality gate. MUST trigger before every commit during sprint execution. Catches schema-reference drift, endpoint regressions, silent scheduled-job failures, broken hard guards, and unreviewed risky changes. Use whenever executing a sprint, fixing a bug, touching AI agent code, changing schema references, or preparing to commit. If you are about to run `git commit` or `git add`, run this gate first. Non-negotiable.
---

# QA Gate: Pre-Commit Quality Assurance

Every commit passes through this gate. No exceptions. It exists because of one bug: a query referenced a column that lives on a different table. It compiled, nothing errored, and a feature plus two scheduled jobs quietly stopped working for every user. We committed without checking runtime behavior. Never again.

**Set up once:** list your project's hard guards and baselines in `CLAUDE.md` (see the "Project constraints" section). This gate checks them. If this file and the repo's own commit hook ever disagree on a number, the hook wins and this file gets fixed (Rule 7).

## When to run
- Before every `git commit`
- After any edit to a service, controller, router or schema file
- After any query change
- After any AI prompt or tool change

## Gate 1: Schema-reference integrity
**Catches:** a column reference that compiles but is undefined at runtime because it belongs to another table.

For every query in the changed files:
1. Identify the table being queried.
2. List every column referenced (select, where, order by, set, values).
3. Open the schema file and confirm each column exists on **that** table.
4. If a column name exists on several tables, confirm the right one.

Keep a **common traps** table in your repo: column names that exist on one table but not on a similar one, and fields that must never be written.

**Verdict:** any mismatch = BLOCKED.

## Gate 2: Standing constraints
Run a scripted check for every hard guard in `CLAUDE.md`. Typical ones:
- Pinned reference counts unchanged from baseline
- Zero writes to read-only fields
- Zero changes to protected files
- Zero direct AI SDK imports outside the one AI client; zero hard-coded model names
- Every new foreign key to a user table covered by account deletion

**Verdict:** any failure = BLOCKED.

## Gate 3: Endpoint smoke test
For every system the commit touches, call its main endpoint with a test account and confirm it isn't a 500. Keep a table in the repo: system, endpoint, method.

**Verdict:** any 500 on a touched system = BLOCKED.

## Gate 4: Type-error count
```bash
npx tsc --noEmit 2>&1 | grep "error TS" | wc -l
```
Must not rise above the baseline in `CLAUDE.md`. Going down is welcome; update the baseline when it does.

## Gate 5: Scheduled-job impact
If any changed file is called by a scheduled job, even indirectly:
1. Name the job(s).
2. Prove each still works: call the function directly and inspect what it wrote. Waiting for a timer is not proof.
3. Add to the commit message: `Job impact: [name] - verified`.

**Verdict:** an affected job left untested = BLOCKED.

## Gate 6: Em dash check
```bash
grep -rn '—' src/ --include="*.ts" --include="*.tsx" | grep -v "node_modules\|:[0-9]*:\s*//"
```
Expected: 0 in user-facing strings. Adjust the paths to your repo.

## Gate 7: Specialist reviews
Three read-only reviewers (in `.claude/agents/` once you copy the playbook's `claude-code/dot-claude` folder into your repo as `.claude`). They report; they never edit.

| Reviewer | Runs when |
|---|---|
| silent-failure-hunter | The commit changes server-side code |
| security-reviewer | The commit touches a sensitive path: auth, sessions, identity checks, payments, uploads and file serving, admin, email tokens, account deletion, secret readers |
| pr-test-analyzer | The commit adds or changes tests, or adds a requirement |

- CRITICAL or HIGH: BLOCKED. Fix it inside the plan, or stop and raise a numbered question. Never widen scope quietly.
- MEDIUM or LOW: one debt-ledger row each.
- A reviewer that couldn't run is NOT RUN, with the reason. Never PASS.

Optional: have your commit hook require `Security review: PASS` (or `FINDINGS LEDGERED (ids)` or `WAIVED by [owner] (ruling N)`) in the message when sensitive paths are staged.

## Gate 8: PRD verified
`PRD: [filename] - all acceptance criteria verified: YES/NO`. NO, or no PRD line, = BLOCKED.

If the sprint has a gates checklist (`docs/prds/gates/<plan name>.md`), run `bash scripts/gates-check.sh` on it and paste the output word for word. YES may only be written when its last line shows 0 open runnable gates. Manual gates (push, publish, smoke) may still be open at commit. Never hand-type a receipt or check a box on a runnable gate. A check that couldn't run is open, never skipped. See the playbook's `process/gates-with-receipts.md`.

## Output format

```
=== QA GATE RESULTS ===
Date:
Plan: [PRD file] | Task: [FR numbers]
Files changed: [count]

Gate 1 - Schema references: PASS / FAIL [details]
Gate 2 - Standing constraints: PASS / FAIL [each guard with its number]
Gate 3 - Endpoint smoke: PASS / FAIL / N/A
Gate 4 - Type errors: [n] (baseline: [n]) PASS / FAIL
Gate 5 - Scheduled jobs: PASS / N/A [details]
Gate 6 - Em dash: PASS / FAIL
Gate 7 - Reviews: Silent-failure PASS/FINDINGS/NOT RUN; Security PASS/FINDINGS/NOT RUN/N/A; Tests PASS/FINDINGS/NOT RUN/N/A
Gate 8 - PRD: [file] - all acceptance criteria verified: YES / NO
Gates checklist: [path] [checker's last line, word for word] / N/A

VERDICT: COMMIT APPROVED / BLOCKED [reason]
```

## When blocked
1. Fix the failing gate.
2. Re-run all gates, not just the one that failed.
3. Commit only when all pass.
4. Put the gate output in the commit message.

## Escalation
If a gate can't pass without breaking a hard guard: don't work around it. Report the gate, what you tried and why it can't be resolved, then wait for explicit approval.

## Make it fail closed
Put the gate in a git commit hook so a commit with no PRD line, or with `verified: NO`, is refused, and make sure the hook can't be quietly switched off. Prove the hook with one refused commit and one accepted commit.
