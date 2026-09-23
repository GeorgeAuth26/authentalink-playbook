# PRD: [Feature / Sprint Name]

| Field | Value |
|---|---|
| Status | Draft / Approved / In Progress / Shipped / Superseded |
| Date | |
| Sprint | |
| Author | Claude (approved by [owner], by name) |
| Classification | Full |
| Related PRDs | |

---

## 1. Problem & Why Now

[One paragraph. What is broken, missing, or weak, in user or business terms, not implementation terms. Why does it matter now? Which leg of B=MAP does it fix: motivation, ability, or prompt? If this paragraph is hard to write, the work is not understood yet.]

**Evidence:** [Bug reports, user feedback, metrics, or observed behavior that proves the problem exists]

## 2. Goals & Success Metrics

| Goal | Metric | Target |
|---|---|---|
| | | |

For AI/agent features, additionally specify:
- Accuracy / quality target: [e.g., at least 90% on labeled test queries]
- Hallucination tolerance: [e.g., <2%]
- Latency budget: [e.g., p95 < 3s]
- Cost budget per call/user: [if relevant]

## 3. Non-Goals (Out of Scope)

[Explicit exclusions. This section prevents scope drift and agent invention more than any other. Be specific: "This does NOT change the billing flow," "This does NOT add columns to the users table."]

- 
- 

## 4. Users & Use Cases

**Affected users/roles:** [e.g., members, admins, signed-out visitors]

**Primary scenarios:**
1. [As a ___, I ___ so that ___. Acceptance: ___]

**Edge-case scenarios:**
1. [New user with no data / user mid-verification / deleted profile / concurrent access / empty states]

## 5. Functional Requirements & Acceptance Criteria

Numbered, testable. These become the qa-gate contract.

| # | Requirement | Acceptance Criterion (testable) | Priority |
|---|---|---|---|
| FR-1 | | | Must |
| FR-2 | | | Should |

## 6. Architecture & Connections (CORE SECTION: codebase inspection required)

### 6.1 Data Model Impact
For every table touched, paste the CURRENT column list from the schema file, then the proposed change:

| Table | Column | Type | Nullable | Default | New/Modified/Read-only | Tables that do NOT have this column |
|---|---|---|---|---|---|---|

Migration required? [Yes/No. If yes, describe forward and backward migration. Additive only.]

### 6.2 Endpoint Contracts
| Method | Path | Request shape | Response shape | Auth | New/Changed | Before, After |
|---|---|---|---|---|---|---|

### 6.3 Agent Impact
[Which AI agents touch this code path? Prompt changes? Tool changes? If none, write "None" explicitly.]

### 6.4 Scheduled Job Impact
[Search the caller chain. Which scheduled jobs call any modified function, even indirectly? Name each and how it's affected. If none, write "None" explicitly.]

### 6.5 Dependency Map
For every modified function/service, list actual callers found via grep:

| Modified item | Callers (file:line) | Risk if behavior changes |
|---|---|---|

### 6.6 Standing Constraint Compliance
Confirm each hard guard from the project's CLAUDE.md in writing, for example:
- [ ] Read-only fields stay read-only (no writes introduced)
- [ ] No protected files touched
- [ ] All AI calls route through the one AI client, with model names as constants
- [ ] Pinned reference counts unchanged from baseline
- [ ] Any new foreign key to a user table is covered by account deletion
- [ ] No em dashes in user-facing strings

### 6.7 New Dependencies
[New packages, APIs, services. Version, license, why existing tools can't do it. If none, write "None".]

## 7. Failure Modes & Edge Cases

| Failure mode | Likelihood | Impact | Detection | Mitigation / graceful degradation |
|---|---|---|---|---|

[Think adversarially: What if the external API is down? The table is empty? Two scheduled jobs race? The model returns malformed output?]

## 8. Rollout & Rollback

- **Rollout:** [Direct deploy / feature flag / phased. Migration ordering if schema changes.]
- **Rollback:** [Exact steps to undo. If schema changed: is the migration reversible? If not, what's the plan?]
- **Switch:** [flag name; publishes off; the owner says when it goes on]
- **Monitoring:** [What to watch during the 72-hour watch: errors, endpoints, scheduled job runs]

## 9. Open Questions & TBDs

Must be empty or ruled by the owner, by name, before Status moves to Approved. Rulings are numbered.

| # | Question | Blocking? | Owner | Resolution |
|---|---|---|---|---|

## 10. Task Breakdown

Agent-sized chunks in dependency order. Each task should be independently verifiable.

| # | Task | Depends on | Files touched | Design board | Verification |
|---|---|---|---|---|---|

---

## Post-Ship Addendum (fill after implementation)

- **What changed from the approved PRD and why:**
- **Final qa-gate output reference:**
- **Lessons for future PRDs:**
