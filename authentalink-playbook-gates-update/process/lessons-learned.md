# Lessons Learned (the injury report)

Each of these cost us real time. Each one is now a rule somewhere in this playbook.

| What happened | The rule it made |
|---|---|
| A query referenced a column that exists on a different table. It compiled fine, and a whole feature plus two scheduled jobs failed silently for every user. | qa-gate Gate 1 (schema references), plus the silent-failure reviewer |
| Two code paths used the same route name. We fixed one, and the screen called the other. | Confirm which path the UI actually calls before editing (Rule 8, GateGuard) |
| Login redirects lost the user's place in production but worked in dev. The session wasn't saved before the redirect, and production's slower database exposed it. | Always await the session save before an OAuth redirect. Dev is not prod. |
| The practice server ran every scheduled job with live email and mailed real members. | The practice environment uses a mail allowlist, and test accounts carry a flag the mailer refuses. |
| A loose search filter printed environment tokens into a session transcript. | Never print env values. Use a "set / not set" script. |
| Files uploaded to our own domain could have opened as pages and run script. | Stored files are served only as media or downloads, with protective headers. The security reviewer checks this on every upload change. |
| Tests "passed" that could never fail: one checked the wrong place, and one passed only because of the order tests ran in. | Removal checks, red then green, on every rule. |
| Screens shipped looking like a form because only PNGs and prose reached the builder. | The design's source file lives in the repo. Side-by-side or it isn't done. |
| We planned from a stale diagnostic doc. | Check the git log on target files before writing a prompt. |
| "Committed" got reported as "shipped." | Shipped = merged + pushed + published + live check. |
| Reports said "verified: YES" before the proofs had run, and one proof was red. Another report's results table looked finished after a crash. | Gates with receipts: only a script checks a box, and the report pastes its output word for word. |
| A hosting tool's editor saved a stray keystroke in the scorecard as its own commit. The commit gate caught it. | Don't open the scorecard in the hosting editor. Only the script and the builder touch it. |
| Prompt tweaks stopped improving an AI feature. | Past a point, fix the structure, not the prompt. Trained habits beat instructions. |
| An advisor council's recommendation quietly parked two designs the founder had approved. | Scope is the founder's alone. Recommendations are questions. |
