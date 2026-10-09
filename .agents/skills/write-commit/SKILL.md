---
name: write-commit
description: Write and make a commit in this repository's format, on a branch that is not main. Use for every commit, once the change is staged.
---

# Write a commit

The rules live in AGENTS.md, "Provenance"; this skill is the procedure.

1. Check the branch: `git branch --show-current`. On `main`, stop; create a
   branch first (create-branch).
2. Read the staged diff (`git diff --cached`). One commit holds one coherent
   change; each commit lands on `main` unchanged.
3. Subject: `<type>(<scope>): <imperative subject>`, 50 characters or fewer,
   with a type and a scope (an area) from CONTRIBUTING.md, "Names";
   `.gitmessage` gives the same shape. Check the length before you commit.
4. Body: bullets of what changed, including which wording you were given and
   which you wrote. This is where the detail of your role goes.
5. `Why:` only for a reason the maintainer supplied, in the issue, the pull
   request, or this session. Otherwise leave it out.
6. End with one trailer block, after a blank line, with no blank line in it
   and nothing after it:
   `Assisted-by: <tool>, <model id or not recorded> (<role>)`, then
   `Checks-run:` for each check you ran. Pick the role as AGENTS.md,
   "Provenance", defines it.
7. Commit from a file: `git commit -F <message file>`. Never add an AI
   `Co-authored-by:` line, and never use `--no-verify`.
8. Check that git reads every trailer: `git log -1 --format='%(trailers)'`.
