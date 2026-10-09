# The AuthentaLink Playbook

**How a solo founder ships real software with AI builders without losing control of the product.**

This is the rulebook we use to build [AuthentaLink](https://authentalink.com). A founder calls the plays. Claude runs the sideline as sprint master. Claude Code builds. Everything here was earned the hard way. Most rules exist because something broke.

It works for any team that builds with AI coding agents, whether you're one person with a day job or a team at a company.

## What's inside

| Folder | What it's for |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | A drop-in rules file for your repo. Claude Code reads it on every session. |
| [`rules/`](rules) | The 12 rules for AI builders, how we talk, and who decides what |
| [`process/`](process) | The sprint loop, **process maps**, the proof standard, gates with receipts, publishing and watching, **one board**, **the second brain**, debt, crash recovery, design to code, handoffs, and lessons learned |
| [`skills/`](skills) | Two Claude skills: **prd-gate** (no code without an approved plan) and **qa-gate** (no commit without passing checks) |
| [`scripts/`](scripts) | **gates-check.sh**, the referee: it reruns every check on a sprint's scorecard and stamps receipts. Only it can check a box. Plus its tests |
| [`templates/`](templates) | A handoff prompt, Lite plan, full plan, process map, gates checklist, post-ship addendum, debt ledger, master plan, one board, BRAIN-UPDATE file, vault librarian rules, and your project's constraints |
| [`claude-code/`](claude-code) | A `.claude` folder (stored as `dot-claude`) you can copy into your repo: three read-only reviewers plus GateGuard, a hook that makes the agent gather facts before it edits |

## The game plan in one minute

1. **No plan, no code.** Every change starts as a Lite or Full plan. The founder approves it by name. Nothing is approved in advance.
2. **Map first.** Every plan carries a process map: every screen, state, email and side. The build is checked against it box by box before merge. Maps come from rulings or code, never memory ([process maps](process/process-maps.md)).
3. **Recon, confirm, then build.** The agent reads the code first, states its plan, and stops. Building starts only when you say go.
4. **Prove it, don't claim it.** Every rule gets a test that goes red when the rule is removed and green when it's put back. "Tests pass" means nothing if the tests can't fail. Every sprint gets a scorecard where only a script can check a box ([gates with receipts](process/gates-with-receipts.md)).
5. **Shipped means shipped.** Merged, pushed, published, and checked on the live site. A commit on a branch is not shipped.
6. **One plan per publish, then watch.** Every publish gets a 72-hour watch. No publishing on weekends and none during another publish's watch.
7. **The founder owns scope.** Advisors, councils and AIs recommend. Only the founder parks, cuts or adds, by name.
8. **Plain words.** Every report answers four questions: what happened, why, what's next, and is it done.
9. **One board, one brain.** Everything left lives on one board, and new ideas answer "why now, and why today?" first ([one board](process/one-board.md)). Every ruling and process lands in one notes vault with Claude as librarian ([second brain](process/second-brain.md)).

## Quick start

**Claude Code (any repo):**
1. Copy [`CLAUDE.md`](CLAUDE.md) to your repo root and fill in the project constraints section.
2. Copy [`claude-code/dot-claude`](claude-code/dot-claude) into your repo root and rename it to `.claude`. See [`claude-code/README.md`](claude-code/README.md).
3. Copy [`skills/prd-gate`](skills/prd-gate) and [`skills/qa-gate`](skills/qa-gate) into `.claude/skills/`, or add them as skills in claude.ai.
4. Copy [`scripts/gates-check.sh`](scripts/gates-check.sh) into your repo's `scripts/` folder. Run `bash scripts/test-gates-check.sh` once to see the referee catch its trick plays.
5. Restart Claude Code.

**claude.ai or Cowork (planning side):** upload the two skills, and use [`templates/PASTE-INTO-CODE.md`](templates/PASTE-INTO-CODE.md) for every handoff to your builder. Draw every plan's map from [`templates/process-map.md`](templates/process-map.md).

**Second brain (optional):** make a notes vault, drop in [`templates/vault-CLAUDE.md`](templates/vault-CLAUDE.md) as its `CLAUDE.md`, and have Claude write [BRAIN-UPDATE files](templates/brain-update.md) into its `Inbox/`. Schedule a nightly filing and a weekly check ([how](process/second-brain.md)).

## Why "AuthentaLink"?

AuthentaLink is a career passport: every claim on it is backed by a real, ID-checked person who saw the work. We hold our code to the same standard: a witness on every claim. This playbook is how.

## Credits

Built by George, founder of AuthentaLink, with Claude. The three reviewers, the interface polish checklist and GateGuard come from [ECC](https://github.com/affaan-m/ECC) (MIT). The gates-with-receipts idea is adapted from [unlazy](https://github.com/Leonxlnx/unlazy) (MIT). See [NOTICE.md](NOTICE.md).

MIT licensed. Take it, change it, make it yours. Pull requests welcome ([CONTRIBUTING.md](CONTRIBUTING.md)).
