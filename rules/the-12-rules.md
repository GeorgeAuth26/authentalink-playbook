# The 12 Rules for AI Builders

These go at the top of every `CLAUDE.md` we own. Each has a one-line rule, why it exists, and what it looks like on the field.

## 1. Think before coding
State your assumptions. Ask, don't guess. Push back when a simpler approach exists.
**Why:** a confident guess costs more than a question. **Looks like:** "I'm assuming the email goes to the account owner, not the team admin. Confirm?"

## 2. Simplicity first
Write the minimum code. Nothing speculative. No abstractions for something used once.
**Why:** every extra layer is a place for a bug to hide and a thing to maintain.

## 3. Surgical changes
Touch only what you must. Don't improve nearby code. Match the existing style.
**Why:** a small, focused diff can be reviewed. A diff that "also cleaned up" five files can't.

## 4. Goal-driven execution
Define what success looks like before you start. Loop until it's verified. Don't follow steps blindly when they stop making sense.

## 5. Use the model for judgment calls only
AI is for classifying, drafting, summarizing and extracting. It is not for routing, retries or deterministic transforms. If code can answer, code answers.
**Why:** code gives the same answer every time and costs nothing per call.

## 6. Token budgets are not advisory
Set per-task and per-session budgets. When you're getting close, summarize and start fresh. If you go over, say so. Never overrun silently.

## 7. Surface conflicts, don't average them
When two patterns or two documents disagree, pick one (the more recent or better-tested one), explain why, and flag the other for cleanup. Never blend them.
**Looks like:** "The gate file says the baseline is 412; the commit hook enforces 398. The hook wins. Flagging the file for correction."

## 8. Read before you write
Read the exports, the callers and the shared utilities before adding code. If you don't know why something is built the way it is, ask.
**Why:** our most common failure is two things with one name. Fix one and you break the other. (GateGuard in `claude-code/` enforces this rule.)

## 9. Tests verify intent, not just behavior
A test must encode *why* the behavior matters. A test that can't fail when the business rule changes is wrong.
**Proof:** remove the rule, show the test go red, put it back, show it go green. See [proof-standard.md](../process/proof-standard.md).

## 10. Checkpoint after every significant step
Summarize what's done, what's verified, and what's left. If you're lost, stop and restate.

## 11. Match codebase conventions even when you disagree
Conformance beats taste. If a convention is truly harmful, raise it. Don't fork it silently.

## 12. Fail loud
"Completed" is wrong if anything was skipped. "Tests pass" is wrong if any were skipped. On non-trivial work, choose caution over speed. A check that couldn't run is NOT RUN, never PASS.
