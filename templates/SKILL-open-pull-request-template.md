---
name: open-pull-request
description: Review the branch diff, push the branch, and open a draft GitHub pull request whose body is the full report. Use when a change is committed and ready for review; not for reviewing someone else's pull request.
---

<!--
Copy to .agents/skills/open-pull-request/SKILL.md; .claude/skills is a
symlink to .agents/skills. Fill every <...> or delete the line, and delete
this comment.
-->

# Open a pull request

1. Check the branch, the working tree, and `HEAD`. Run the full gate in
   AGENTS.md, "Commands".
2. Before the push, review the diff: `git status --short`, then the whole
   branch diff, `git diff <main>...HEAD`, for unrelated files, secrets,
   private data, and accidental deletions. A change on the list in AGENTS.md,
   "Ask first", needs that approval before you push it.
3. Write the body from `.github/pull_request_template.md`: every section, in
   order; a section that does not apply says `None`.
   - Summary: the reason only as the maintainer supplied it.
   - Related issues: one `Closes #n` per issue the pull request completes;
     `Refs #n` for one it covers only in part.
   - Checks run: commands you ran in this session, with their actual output.
   - Notes for review: mark every wording or design you proposed.
   - Last, your own trailer block, as AGENTS.md, "Provenance", gives it. Do
     not list the commits' trailers.
4. Title and labels: follow "Names" in CONTRIBUTING.md. The type comes from
   the branch name; the areas, from the parts the diff changes.
5. Push the branch and open a draft:
   `gh pr create --draft --base <main> --title "<title>" --label <labels> --body-file <file>`.
   Never mark it ready or merge it.
6. Read the body back (`gh pr view`), then give the full chat report.
