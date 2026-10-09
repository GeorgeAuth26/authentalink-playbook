# The Second Brain

**One playbook the whole team reads from.** AI chats forget. Project docs pile up until nobody knows which one is current. A second brain fixes both: one notes vault that feeds code, product and business decisions, with Claude as its librarian.

We use an [Obsidian](https://obsidian.md) vault (plain markdown files on your computer). Any folder of markdown files works the same way.

## The setup

```
Your-Brain/
  CLAUDE.md          The librarian's rulebook. Claude reads it first, every time.
  Home.md            Dashboard and the approved tag list
  Master Status.md   What's true right now, plus "Conflicts to check"
  Inbox/             Drop zone for BRAIN-UPDATE files
  Project/           Sprints, product, go-to-market, decisions, people
  Knowledge/         Frameworks you think with
  Archive/           Anything superseded. Nothing is ever deleted.
  Personal/          Off limits to the librarian
  _templates/        Sprint, decision, meeting, knowledge, person
```

Start from [templates/vault-CLAUDE.md](../templates/vault-CLAUDE.md).

## How facts get in: BRAIN-UPDATE files

Nobody edits the vault by hand in the middle of a work session. Instead, when a session produces something durable (a ruling, a new process, a status change), Claude writes a **BRAIN-UPDATE file** and it lands in the vault's `Inbox/` (or your Downloads folder).

- One file per subject, named `BRAIN-UPDATE-YYYY-MM-DD-<subject>.md`.
- Frontmatter says what kind of note it is and where it goes.
- It holds only facts that were ruled or said, never guesses.

Template: [templates/brain-update.md](../templates/brain-update.md).

## The librarian's rules

1. **Never delete.** Superseded content moves to `Archive/`. History is how you find out why.
2. **Never touch `Personal/`.**
3. **Update notes in place.** One note per subject. No "v2" copies, no new note for every update.
4. **Only file facts from update files or the vault itself.** Not from memory, not from guesses.
5. **Newer fact wins, older fact gets flagged.** When two facts disagree, the newer one goes in the note and the older one is listed under **Conflicts to check** in Master Status, so a human rules on it.
6. **Frontmatter on every note** (type, status, created, updated, tags) and links between related notes, so search and graphs work.
7. **Never run git in the vault if a sync plugin already does.** Two things committing the same folder will fight.

## The rhythm

| When | What the librarian does |
|---|---|
| Nightly (we use 9 pm) | Files every BRAIN-UPDATE file in the Inbox and Downloads, then moves the processed files to `Archive/Brain Updates/` |
| Weekly (we use Sunday night) | Vault check: broken links, notes missing frontmatter, Master Status items older than 30 days |
| End of every sprint | Master Status updated: what shipped, what's next, what's waiting on the founder |

Both jobs run as scheduled tasks, so nobody has to remember them.

## Sync

Turn on a git sync plugin (Obsidian Git, every 10 minutes for us) so the vault is backed up and readable from a cloud session. The vault lives on your computer; the sync copy is how your AI tools read it when your laptop is closed.

## Why it works (B=MAP)

- **Motivation:** decisions stop getting re-made because nobody could find the first one.
- **Ability:** dropping a file in a folder is the smallest possible action.
- **Prompt:** the nightly job is the reminder. Nobody has to remember to file.

## What goes where

| Kind of thing | Home |
|---|---|
| What's true today, open conflicts | Master Status |
| Live plan for the current push | The one board (see [one-board.md](one-board.md)) |
| How a shipped flow actually works | The process atlas (see [process-maps.md](process-maps.md)) |
| Rulings, processes, lessons, people | The vault |
| Prompts for the builder | Handed over in chat as `PASTE-INTO-CODE-N` files, never only filed |
