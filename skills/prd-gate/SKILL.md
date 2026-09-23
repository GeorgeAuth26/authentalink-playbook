---
name: prd-gate
description: Mandatory plan-first gate. MUST trigger at the START of every sprint, feature request, enhancement, or refactor, before any code is written. No code without an approved PRD (Lite or Full). Use whenever the user says "new sprint", "let's build", "add a feature", "next sprint", describes new functionality, or asks for any change that touches architecture, schema, AI agents, scheduled jobs, or integrations. If you are about to write or edit code and no approved plan exists for the work, stop and run this gate first. Pairs with qa-gate.
---

# PRD Gate: Spec Before Code

Every sprint starts here. The point is to think through every angle, every connection and every architectural consequence BEFORE writing code, so qa-gate has a contract to verify against and we never ship a bug born from an unexamined assumption.

**The rule: no approved PRD, no code. No exceptions.**

## Workflow

1. **Classify** the work (Lite or Full, decision tree below).
2. **Scaffold** the PRD in `docs/prds/` from the template.
3. **Fill every section** from codebase inspection and the conversation. Mark real unknowns `TBD: [what's needed to resolve]`. Never leave a section blank or skip one silently. Collapsing a section needs a one-line reason.
4. **Interrogate the connections.** Section 6 is the heart of the document: do the codebase archaeology, don't guess.
5. **Present to the owner for approval.** Surface open questions and TBDs, each with a recommendation. Wait for an explicit yes by name. Nothing is approved in advance.
6. **Build against the PRD.** Its acceptance criteria are the checklist qa-gate verifies before commit.
7. **Update after ship.** If decisions changed during the build, update the PRD to match what shipped and mark it `Status: Shipped`. A PRD that lies about the system is worse than no PRD.

## Decision tree: Lite or Full

Ask: **"Does this change how parts of the system connect?"**

**Full PRD** if the work involves ANY of:
- New or changed tables or columns
- New endpoints, or changes to an endpoint's contract
- Any AI agent's behavior
- Any code path a scheduled job calls, even indirectly
- A new third-party integration or SDK
- Auth, payments, identity, permissions, or any score or status users rely on
- More than 3 files across module boundaries

**Lite PRD** only if ALL of these are true:
- One module, 3 files or fewer
- No schema, endpoint, agent or scheduled-job impact
- No new dependencies
- The change is cosmetic or isolated (copy, styling, log messages, config values)

When in doubt, Full. An unnecessary Full PRD costs 20 minutes. A missed connection costs days.

## File convention

```
docs/prds/
  PRD-2026-08-15-feature-name.md    (Full)
  LITE-2026-08-15-small-change.md   (Lite)
```

Status at the top of every PRD: `Draft -> Approved -> In Progress -> Shipped -> Superseded`

## Lite template

```markdown
# LITE: [Change name]
Status: Draft | Date: | Sprint:

**Problem:** [1-2 sentences: what's wrong or missing, and why it matters]
**Change:** [What will be done, which files]
**Out of scope:** [What this does NOT touch]
**Connections checked:** [Confirm: no schema / no endpoints / no agents / no scheduled jobs / no new deps]
**Acceptance criteria:** [Testable statements]
**Risk:** [Worst case + rollback plan]
```

If any "Connections checked" item turns out false while you write it, upgrade to Full immediately.

## Full template

The full template is at `assets/prd-template.md`. Sections:

1. **Problem and why now.** One paragraph in user terms. Name which leg of B=MAP (motivation, ability, prompt) it fixes.
2. **Goals and success metrics.** Measurable. For AI features: accuracy, hallucination, latency and cost targets.
3. **Non-goals.** Explicit exclusions. This section prevents agent drift more than any other.
4. **Users and use cases,** including edge cases.
5. **Functional requirements and acceptance criteria.** Numbered FR-1, FR-2, each testable. These are qa-gate's contract.
6. **Architecture and connections.** THE CORE SECTION.
7. **Failure modes and edge cases.**
8. **Rollout and rollback.** Switch (feature flag) name, migration order, how to undo.
9. **Open questions and rulings.** Must be empty or ruled by name before Approved.
10. **Task breakdown.** Agent-sized chunks in dependency order, each naming its design board if it's UI.

## Section 6 discipline

Fill it from the actual code, not memory:
- **Data model:** for every table touched, paste the current column list from the schema file. For each new or changed column: name, type, nullability, default, and which similar tables do NOT have it (the wrong-table trap).
- **Dependency map:** for every function or service you change, search for its callers and list them. If a scheduled job is in the chain, name it.
- **Endpoint contracts:** method, path, request, response, auth, before and after.
- **Standing constraints:** confirm in writing that the design respects every hard guard in the project's `CLAUDE.md`.

## Approval gate

Present with:
- A 3 to 5 sentence summary (what, why, biggest risk)
- The open questions, each with a recommendation
- Lite or Full, and why

Don't start until the owner says approved. If something mid-build invalidates part of the PRD: STOP, update the PRD, flag it, and get re-approval on the changed sections.

## Handoff to qa-gate

- Every acceptance criterion is verified before commit.
- Every scheduled job named in Section 6 appears in qa-gate's scheduled-job check.
- Every schema change passes qa-gate's schema check.
- The qa-gate output includes: `PRD: [filename] - all acceptance criteria verified: YES/NO`. A NO blocks the commit.

## Escalation

If the work conflicts with a standing constraint or needs architecture changes beyond the sprint: don't expand scope or work around it. Write the conflict into Open Questions, present options with trade-offs, and wait for direction.
