# Publish and Watch

## The rules
- **One plan per publish, one publish per plan.** Bundling needs a one-time waiver by name.
- **Every new surface ships behind a switch** (feature flag), and publishes with the switch **off**. The builder checks the live site with it off. Then the founder says "on," and it's switched on. Rollback is switching it off.
- **Shipped means all four:** merged to main, pushed, published, and checked live (the builder runs the live check; the founder does a final smoke test). A branch commit is not shipped.
- **72-hour watch after every publish.** During the watch: builds may continue, but nothing else publishes.
- **No publishing on weekends.**
- **Success line.** Every publish names, before it goes out, what real-world event proves it worked. For example: "one stranger completes the flow end to end."

## The live check (right after publish)
Served files match the proven build. Switches read what they should. New addresses answer "not found" while off. Error tracking is quiet. One real email, if email changed, read in a real inbox.

## Browser QA (read-only, test accounts only)
Console errors, failed network calls, phone and desktop screenshots, and no mutating journeys (payments, deletes) against production.

## Close read (end of the watch)
Errors, analytics by source, anything odd. Then the post-ship addendum.

## Dates slide one for one
If a plan isn't approved in time, every date behind it moves by the same amount. Say so the day it happens.
