# Process Maps

**Draw the play before you run it.** Every sprint gets a map, start to finish, before the plan is approved.

## Why

We ran a check of our live product against what we thought we had built. It found 15 differences and 8 cracks. None of them were bad code. Every one was a gap between what the founder had ruled and what everyone remembered. A 400-line plan takes an hour to read. A map takes 30 seconds, so gaps show up before the build instead of after it.

## The rule

1. **Map first.** Before the founder approves any plan, the sprint master draws its map: every screen, every state (loading, in flight, success, error, empty, expired), every email, and every side of the flow (the asker, the confirmer, the viewer). The founder's approval by name covers the map. **No map, no approval.**
2. **The map is the contract.** Every box on the map gets a line in the plan's gate: the file that builds it and the test that proves it. The builder builds to the map, not to the prose.
3. **The builder checks the map before merge.** In qa-gate, every box gets one of three marks, with file and line:
   - **Match:** built as drawn.
   - **Different:** built, but not as drawn. One Different stops the merge.
   - **Not built:** missing. Stops the merge unless the plan says it comes later.
4. **The live check walks the map.** After publish, someone clicks through the real site box by box.
5. **The atlas gets updated.** Shipped maps move from Planned to Live in the **process atlas**, the living record of how the product actually works. The builder re-checks the atlas after every publish.

## Two rules on top

- **Draw from rulings or from code, never from memory.** A map is not trusted until the builder has checked it against the code.
- **A ruling that changes a flow changes the map the same day,** by name. That way a reversal is never lost. (We once reversed a decision on a confirmation link and reversed it back four days later. Without the map, nobody could say which version was current.)

## Where things live

| What | Where |
|---|---|
| Maps for planned work | Inside the plan (Lite or Full). One map per plan. No separate map documents. |
| Maps for shipped work | The process atlas: one page or artifact, one card per flow, each marked Planned or Live |
| Cracks found by any check | Only in the atlas's cracks section. One list, one place. |

## How good is AI at this?

- **Drawing a map from a written plan or from rulings:** very good. Fast, and every box can be traced to a ruling.
- **Drawing a map of what exists today:** bad, unless it reads the code. Our first atlas, drawn from docs and memory, was wrong on 16 of 37 checks. The builder's version, drawn from the code, was right on all 37. Same tool, different source. That's why the "never from memory" rule exists.

## What it costs

About an hour per plan to draw and approve the map, and about half an hour of builder time per handoff to check it. Cheap next to a week spent fixing a flow nobody drew.

## Template

Start from [templates/process-map.md](../templates/process-map.md). A Mermaid flowchart works well: it renders on GitHub, in claude.ai artifacts and in most note apps.
