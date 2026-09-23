# Design to Code

We once shipped screens that looked "like a Google form from 2012" because the design's source never reached the repo. Pictures plus a written spec produce forms. Here's what we do now.

- **The design canvas's source file lives in the repo** (the generator with the exact markup and tokens). Every UI prompt points at it. Change the design there first, re-render, then match the code to it.
- **Every UI task names its board.** A plan without a named board per UI task is not approved.
- **Design every side of a multi-party flow**: the asker, the confirmer, the viewer. Lean mobile, but every screen gets a desktop version too.
- **Spec every state**: loading, in flight, success, error, empty, expired.
- **Side-by-side or it isn't done**, at 375 and 1440 widths.
- **Brand tokens win** over any generic polish checklist. The polish checklist in `claude-code/` names gaps; only fix a gap when the board agrees.
- **Every plan and timeline shows where every existing board lands** (which publish). If a ruling parks a design, say so by name.
