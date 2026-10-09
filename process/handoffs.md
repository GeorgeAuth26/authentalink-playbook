# Handoffs Between Planner and Builder

The sprint master (Claude in claude.ai or Cowork) writes. The founder carries. The builder (Claude Code) builds.

## PASTE-INTO-CODE-N
Every prompt for the builder is a file named `PASTE-INTO-CODE-N`, handed to the founder in chat, numbered in order forever. Template: [templates/PASTE-INTO-CODE.md](../templates/PASTE-INTO-CODE.md).

Each one:
1. Opens with "Confirm your plan before writing any files."
2. Lists its rulings at the top, numbered, with the founder's answer filled in. A blank ruling means that section is skipped.
3. Starts with a read-only status step (S0).
4. Numbers its sections (S1, S2...) and says where to stop.
5. Ends with the standing guards, a self-QA checklist and the report format.

## One master plan
One living plan doc per project, updated in place. No new docs for every update: too many docs means nobody knows where anything is. The master plan holds the calendar, the numbered rulings, every handoff's result, the open questions for the founder, and where every design lands.

## A visible board
A one-screen board (a page or artifact) for status at a glance. The master plan is the full record; the board is the scoreboard. For a big push, the board becomes the one list of everything left. See [one-board.md](one-board.md).

## When the builder must restart
Some hosted shells can't restart the builder mid-session; the only restart is ending the session, which wipes its memory. So any handoff that needs a restart ends the session, and the next handoff is written for a builder with zero context: every path, ruling and baseline spelled out.

## Durable facts go to the second brain
Rulings, new processes and status changes leave the chat as BRAIN-UPDATE files for the vault. See [second-brain.md](second-brain.md).
