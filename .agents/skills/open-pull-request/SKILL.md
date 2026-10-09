---
name: open-pull-request
description: Review the branch diff, push the branch, and open a draft pull request whose body is the full report. Use when a change is committed and ready for review; not for reviewing someone else's pull request.
---

# Open a pull request

1. Check the branch, the working tree, and `HEAD`. Run the checks in
   AGENTS.md, "Commands".
2. Before the push, review the diff: `git status --short`, then the whole
   branch diff, `git diff main...HEAD`, for unrelated files, secrets, private
   details, local paths, and accidental deletions. A change on the list in
   AGENTS.md, "Ask first", needs the maintainer's approval before you push it.
3. Write the body in the order AGENTS.md, "Report back", gives: every section;
   a section that does not apply says `None`.
   - Summary: the reason only as the maintainer supplied it.
   - Related issues: one `Closes #n` per issue the pull request completes;
     `Refs #n` for one it covers only in part.
   - Checks run: commands you ran in this session, with their actual output.
   - Notes for review: mark every wording or design you proposed.
   - Last, your own trailer block (AGENTS.md, "Provenance"). Do not list the
     commits' trailers.
4. Title: in the commit subject format from CONTRIBUTING.md, "Names"; it
   becomes the merge commit's subject.
5. Labels, from "Names": one `type:` label, the branch's type, and an `area:`
   label for each area the diff changes. If a label does not exist, give the
   maintainer the `gh label create` command; do not run it.
6. Push the branch and open a draft:
   `gh pr create --draft --base main --title "<title>" --label <labels> --body-file <file>`.
   Never mark it ready or merge it.
7. Read the body back (`gh pr view`), then give the full chat report.
