# The Proof Standard

"It works" is a claim. These are the receipts.

1. **Removal checks.** Every rule has a test. Remove the rule and show the test go red, then restore it and show it go green. Report the count. A test that stays green with the rule removed is broken. Fix the test before trusting it.
2. **Test counts name their command.** "3 failed / 1,200 passed / 10 skipped of 1,213 (npm test)." Known failures are listed as inherited. New ones are zero.
3. **Baselines hold.** Type-error count, pinned reference counts, and any other hard guard: the same or better on every commit.
4. **Switch-off proof.** When new work ships behind a switch, prove that with the switch off the site is byte for byte the same as main: every payload and every screen compared. Name every difference.
5. **Side-by-sides.** Every UI task ends with a screenshot of the built screen next to its board, at phone (375) and desktop (1440) width, on a quiet machine. Differences kept on purpose are listed.
6. **Per-state specs.** Every screen is specced and proven per state: loading, in flight, success, error, empty, expired. Not per page.
7. **Scheduled jobs are proven directly.** Call the function and inspect the row it wrote. Waiting for a timer is not proof.
8. **Test data is counted.** Fixtures live in the practice database only, and are removed and counted afterward.
9. **Dev is not prod.** They are different systems, not just different data. A dev confirmation is not a prod confirmation.
10. **Reviewers report.** On the kinds of changes they cover, the silent-failure, security and test reviewers run before commit (see `claude-code/`). CRITICAL or HIGH blocks the commit.
11. **Receipts, not claims.** Every acceptance criterion is a gate on the sprint's scorecard, and only the checker script can mark it met. The report pastes the checker's output word for word. See [gates-with-receipts.md](gates-with-receipts.md).
