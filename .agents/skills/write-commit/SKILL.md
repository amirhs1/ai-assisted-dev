---
name: write-commit
description: Write and make a commit in this repository's format. Use for every commit.
---

# Write a commit

The rules live in AGENTS.md, "Commit format"; this skill is the procedure.

1. Read the staged diff (`git diff --cached`). One commit holds one coherent
   change; each commit lands on `main` unchanged.
2. Subject: `<type>(<scope>): <imperative subject>`, 50 characters or fewer,
   with the types and scopes in `.gitmessage`. Check the length before you
   commit.
3. Body: bullets of what changed, including which wording you were given and
   which you wrote. This is where the detail of your role goes.
4. `Why:` only for a reason the maintainer supplied, in the issue, the pull
   request, or this session. Otherwise leave it out.
5. End with one trailer block, after a blank line, with no blank line in it
   and nothing after it:
   `Assisted-by: <tool>, <model id or not recorded> (<role>)`, then
   `Checks-run:` for each check you ran. Pick the role as AGENTS.md, "Commit
   format", defines it.
6. Commit from a file: `git commit -F <message file>`. Never add an AI
   `Co-authored-by:` line, and never use `--no-verify`.
7. Check that git reads every trailer: `git log -1 --format='%(trailers)'`.
