---
name: write-commit
description: Write and make a commit in this project's format. Use for every commit.
---

<!--
Copy to .agents/skills/write-commit/SKILL.md; .claude/skills is a symlink to
.agents/skills. Adjust the block's first line to the project's commit
convention. Fill every <...> or delete the line, and delete this comment.
The trailer rules live in AGENTS.md, "Provenance"; this skill is the procedure.
-->

# Write a commit

1. Read the staged diff (`git diff --cached`). One commit holds one coherent
   change.
2. Write the message in this shape, whether or not the project has a
   `.gitmessage`:

   ```text
   <type>(<scope>): <subject>

   <what changed>

   Why: <reason the maintainer supplied; omit otherwise, never a placeholder>

   Assisted-by: <tool>, <model identifier or not recorded> (<role>)
   Checks-run: <check actually run> — <observed result>
   Ground-truth-source: <independent source of a reference value>
   ```

   - Subject: imperative, with the types and scopes in AGENTS.md.
   - Body: bullets of what changed, including which wording or code you were
     given and which you wrote. This is where the detail of your role goes.
   - `Why:` only for a reason the maintainer supplied, in the issue, the pull
     request, or this session. Otherwise leave it out.
   - Trailers: one block, after a blank line, with no blank line in it and
     nothing after it. Pick each trailer and the role as AGENTS.md,
     "Provenance", defines them.
3. Commit from a file: `git commit -F <message file>`. Never add an AI
   `Co-authored-by:` line, and never use `--no-verify`.
4. Check that git reads every trailer: `git log -1 --format='%(trailers)'`.
