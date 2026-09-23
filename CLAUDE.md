# CLAUDE.md

Rules for any AI agent working in this repo. From the AuthentaLink Playbook: https://github.com/GeorgeAuth26/authentalink-playbook

## How we work
- **No approved plan, no code.** Run the prd-gate skill first. Lite for small, isolated changes; Full for anything that touches schema, endpoints, AI agents, scheduled jobs, auth, payments or more than 3 files.
- **Recon, confirm, stop.** Read first, state your plan, and wait for an explicit GO.
- **qa-gate before every commit.** It fails closed.
- **One commit per task**, naming the plan and its requirement numbers.
- **Shipped = merged to main + pushed + published + checked live.** Nothing less is shipped.
- **Clean tree at the end of every turn.** Never force-push main.

## The 12 rules
1. **Think before coding.** State assumptions, ask don't guess, push back when a simpler way exists.
2. **Simplicity first.** Minimum code, nothing speculative, no single-use abstractions.
3. **Surgical changes.** Touch only what you must. Match the existing style.
4. **Goal-driven.** Define success first. Loop until verified.
5. **Model for judgment only.** If code can answer, code answers.
6. **Token budgets are real.** Per task: ____. Per session: ____. Surface a breach; never overrun silently.
7. **Surface conflicts.** Pick the more recent or better-tested pattern, say why, flag the other.
8. **Read before you write.** Exports, callers, shared utilities.
9. **Tests verify intent.** Every rule gets a removal check: red with it removed, green with it restored.
10. **Checkpoint every significant step.** Done, verified, left.
11. **Match conventions.** Raise harmful ones; don't fork silently.
12. **Fail loud.** Skipped means not done. NOT RUN is never PASS.

## Reporting
Plain words. Answer: what happened, why, what's next, is it done, and what it means for the customer. Never print a secret or environment value.

## Project constraints (fill these in)
<!-- The hard guards the qa-gate checks. Examples from our repo, made generic: -->
- Type-error ceiling: ____ (must not rise)
- Files no agent may touch: ____
- All AI calls go through: ____ (one client file, model names as constants)
- Read-only fields: ____
- Schema changes are additive only; no destructive migrations or schema push
- Every new foreign key to a user table is covered by account deletion
- No em dashes in user-facing strings
- Switches (feature flags) publish off; the founder says when they go on
