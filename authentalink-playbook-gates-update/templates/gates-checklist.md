# Gates: [plan name]

<!--
Copy to docs/prds/gates/<plan basename>.md when the plan is approved,
before any build code. One gate per acceptance criterion.

Runnable gate: CHECK (a command) + EXPECT (text printed only on success).
Manual gate: no CHECK, no EXPECT. A person signs the RECEIPT.
Optional: TIMEOUT: <seconds> (default 120). LAST: yes on the qa-gate gate.
Every gate needs a RECEIPT line. Only scripts/gates-check.sh fills in
runnable receipts. See process/gates-with-receipts.md.
-->

- [ ] G1: [FR-1 outcome someone can observe, not an activity]
  CHECK: [command that looks directly at the thing]
  EXPECT: [a word printed only after every assertion passes]
  RECEIPT: pending

- [ ] G2: [FR-2 outcome]
  CHECK: [command]
  EXPECT: [success word]
  RECEIPT: pending

- [ ] G3: qa-gate passes (always the last runnable gate)
  CHECK: [your qa-gate command]
  EXPECT: [its pass line]
  TIMEOUT: 300
  LAST: yes
  RECEIPT: pending

- [ ] G4: pushed to origin/main (founder)
  RECEIPT: pending

- [ ] G5: published to production (founder)
  RECEIPT: pending

- [ ] G6: live smoke test passes (founder)
  RECEIPT: pending
