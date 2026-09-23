# The Debt Ledger

Don't guess at tech debt. Measure it, sort it, schedule it.

## Four buckets
1. **Dead weight.** Features nobody uses. Any route with zero real visitors in 30 days gets a removal ticket. Deleting unused code is the cheapest cleanup there is.
2. **Known conflicts.** Two things doing one job (two email clients, two headers). Pick a winner and remove the loser.
3. **Touch-when-near.** Fixed only inside the ticket that already touches that code. Never as a side quest (Rule 3).
4. **Leave alone.** Works, nobody touches it, no customer cost.

## Rules
- **No new debt without a ledger line.** Every plan's post-ship addendum adds its leftovers. If it's not on the ledger, it doesn't exist.
- **Cleanup sweep after every two feature publishes.** Never more than one day of builder time. Removals ship with a git tag so they can be restored.
- **Every removal is a question** the founder answers by name.
- Reviewer findings rated MEDIUM or LOW land here, one row each.
