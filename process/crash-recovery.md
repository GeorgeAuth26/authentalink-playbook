# Crash Recovery

AI builders crash: containers restart, sessions die, logins expire. Plan for it.

- **Commit per task.** A crash loses at most one task. Local commits are checkpoints.
- **The next handoff after a crash starts with a read-only status step.** Branch tips, uncommitted files, what's on the remote, dangling work. Reconstruct from git evidence, not memory.
- **Carry the section text again.** A crashed session lost the handoff, so re-send the unfinished sections word for word.
- **Never force-push main.** If an auto-save commit swept up work: replace it with a named commit if it's unpushed, and commit on top if it's already on the remote.
- **Nobody uses a hosting tool's Git pane for Pull, Rebase, Resolve or Discard.** The builder pushes. The founder only reconnects the login when it dies. (We once came within one click of flattening a merge that way.)
- **Clean tree at the end of every turn.** Anything left staged can get swept into an automatic commit.
- **A session token pasted in a link is a password.** Log out and back in to kill it.
