# The Sprint Loop

Every piece of work runs the same play.

```
Plan (Lite or Full) -> Founder approves by name -> Recon -> Plan-confirm STOP -> GO
  -> Build (one commit per task) -> Proofs -> qa-gate -> Commit -> Push
  -> Publish (switch off) -> Live check -> Switch on (founder says) -> 72-hour watch
  -> Close read -> Post-ship addendum
```

## 1. Plan
Run the prd-gate. **Lite** when every one of these is true: one module, 3 files or fewer, no schema, endpoint, AI agent or scheduled job impact, no new dependencies. Otherwise **Full**. When in doubt, Full: an unneeded Full plan costs 20 minutes, and a missed connection costs a week.

The heart of a Full plan is **Architecture & Connections**: paste the real current columns of every table touched, list every caller of every changed function (found by search, not memory), and name every scheduled job in the caller chain.

## 2. Approve
The founder reads the plan and says yes by name. Open questions go into the plan with a recommendation each; the founder rules them. Rulings are written into the plan before any code.

## 3. Recon, then stop
Every handoff opens with "Confirm your plan before writing any files." The builder does a read-only recon: branch tips, a clean tree, the current baselines, the git log on the target files (diagnostic docs go stale), and the plan lines that no longer match the code. Then it states its plan and stops.

**Sub-decision pauses are mandatory** when work touches the schema and a scheduled job together, or when scope grows materially mid-build.

## 4. Build
One commit per task, each naming the plan and its requirement numbers (FR-3, FR-4). Each UI task names the design board it builds.

## 5. Prove
See [proof-standard.md](proof-standard.md). Then qa-gate. It fails closed.

## 6. Ship
See [publish-and-watch.md](publish-and-watch.md).

## 7. Close
After the watch: a close read (errors, analytics, anything odd), then the **post-ship addendum**: what changed from the plan and why, the final gate output, and lessons. A plan that lies about the system is worse than no plan, so update it to match what shipped.

## Rhythm
- **Builds may overlap another publish's watch. Publishes may not.**
- Exception: a *fix* is finished first. No new build or diagnosis starts on top of a fix until that fix is published and smoke-tested.
- Bias to action inside the rules: "run it now and measure" beats "wait for X, then Y."
