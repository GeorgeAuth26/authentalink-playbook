# Claude Code Setup

Copy the `dot-claude` folder into your repo root and rename it to `.claude` (it's stored without the dot so it's easy to see and download):

```bash
cp -r claude-code/dot-claude /path/to/your-repo/.claude
```

 If you already have a `.claude/settings.json`, merge the `env` and `hooks` sections into it rather than overwriting it. Then restart Claude Code.

## What you get

| Piece | What it does | How it runs |
|---|---|---|
| `agents/silent-failure-hunter.md` | Hunts swallowed errors, fake-success fallbacks, and webhooks or jobs that fail quietly | Read-only subagent. Ask for it, or have qa-gate call it before commit |
| `agents/security-reviewer.md` | Checks auth, identity data, payments, uploads, admin, tokens, secrets | Read-only subagent, on sensitive paths |
| `agents/pr-test-analyzer.md` | Asks whether the new tests can actually fail, and what isn't tested | Read-only subagent, when tests change |
| `skills/make-interfaces-feel-better` | A polish checklist: spacing, type, hit areas, states, motion | Read during UI side-by-sides |
| `hooks/ecc/` (GateGuard) | Before the first edit of any file, the agent must list who imports it, what changes, and quote your instruction. It also gates destructive commands (`rm -rf`, `git reset --hard`, force-push, `DROP TABLE`, schema push) | Automatic hook, Node built-ins only |

Requires Node 18 or newer.

## Tuning GateGuard (in `settings.json` under `env`)

- `GATEGUARD_EXEMPT_GLOBS`: paths that skip the first-edit gate (docs, tests).
- `GATEGUARD_BASH_EXTRA_DESTRUCTIVE`: extra commands to treat as destructive. The default adds `db:push` and `drizzle-kit push`; change it for your stack.
- `GATEGUARD_BASH_ROUTINE_DISABLED=1`: skips the once-per-session gate on ordinary commands. Destructive commands are still gated.
- To turn it off for one session: start Claude Code with `ECC_GATEGUARD=off`.

## Check that it works

```bash
echo '{"session_id":"t","tool_name":"Bash","tool_input":{"command":"rm -rf build"},"cwd":"'"$PWD"'"}' \
  | GATEGUARD_STATE_DIR=$(mktemp -d) node .claude/hooks/ecc/gateguard-hook.js
```

You should see a `"permissionDecision":"deny"` answer asking for a list of what will be deleted and a rollback plan.

## Source

In `dot-claude/`, everything except `gateguard-hook.js` and the "House rules" sections is from [ECC](https://github.com/affaan-m/ECC) at commit `bf70150eb2df8070024e5bdf08e4aa08959e2735`, MIT license. See [NOTICE.md](../NOTICE.md).
