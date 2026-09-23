# Project Constraints (hard guards)

Paste into your `CLAUDE.md`. The qa-gate checks every line. Update a number only in the same commit that changes it, and say why.

| Guard | Value | How it's checked |
|---|---|---|
| Type-error ceiling | ____ | `npx tsc --noEmit \| grep -c "error TS"` |
| Pinned reference count ([function]) | ____ | grep count |
| Read-only fields | ____ | grep for writes |
| Protected files (no agent edits) | ____ | staged-file check |
| AI client | all calls via ____; models as constants | grep for direct SDK imports and model strings |
| Schema | additive only; no schema push | GateGuard + review |
| Account deletion | covers every FK to ____ | review on schema change |
| Sensitive paths (security review) | ____ | commit hook glob list |
| Copy | no em dashes; banned words: ____ | grep guard |
| Switches | publish off; owner says on | switch-off proof |
