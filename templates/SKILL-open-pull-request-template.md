---
name: open-pull-request
description: Push the branch and open a draft pull request whose body is the full report. Use when a change is ready for review.
---

<!--
Copy to .agents/skills/open-pull-request/SKILL.md; .claude/skills is a
symlink to .agents/skills. Fill every <...> or delete the line, and delete
this comment.
-->

# Open a pull request

1. Check the branch, the working tree, and `HEAD`. Run the full gate in
   AGENTS.md, "Commands".
2. Write the body from `.github/pull_request_template.md`: every section, in
   order; a section that does not apply says `None`.
   - Summary: the reason only as the maintainer supplied it.
   - Related issues: one `Closes #n` per issue the pull request completes;
     `Refs #n` for one it covers only in part.
   - Checks run: commands you ran in this session, with their actual output.
   - Notes for review: mark every wording or design you proposed.
   - AI assistance, last: tool, model, role, then the branch's `Assisted-by:`
     lines from
     `git log --no-merges --format=%B <main>..HEAD | grep '^Assisted-by:'`.
3. Title and label: follow "Names" in AGENTS.md, "Git"; a pull request that
   closes an issue takes that issue's label.
4. Push the branch and open a draft:
   `gh pr create --draft --base <main> --title "<title>" --label <label> --body-file <file>`.
   Never mark it ready or merge it.
5. Read the body back (`gh pr view`), then give the full chat report.
