---
name: draft-release
description: Draft a GitHub release and its changelog section in Common Changelog form; never publish it. Use only when the person running you asks for a release.
disable-model-invocation: true
---

<!--
Copy to .agents/skills/draft-release/SKILL.md; .claude/skills is a symlink to
.agents/skills. disable-model-invocation keeps an agent from loading this
skill on its own; a person invokes it. Fill every <...> or delete the line,
and delete this comment.
-->

# Draft a release

1. Check the branch, the working tree, and `HEAD`: on `<main>`, clean, and
   level with `origin/<main>`.
2. Tag and title: `v<MAJOR>.<MINOR>.<PATCH>`, as CONTRIBUTING.md, "Names",
   sets them. The person running you chooses the version.
3. List the changes since the last tag:
   `git log --no-merges --format='%h %s' <last tag>..HEAD`.
4. Write the release's changelog section in Common Changelog form
   (https://common-changelog.org): categories Changed, Added, Removed, Fixed,
   in that order, each only when it has a change; one imperative line per
   change, with a commit or pull request reference; no Unreleased section.
5. Add the section to the top of CHANGELOG.md on a new branch, and open a
   pull request for it.
6. Create the draft, with the section as its notes and your trailer block
   (AGENTS.md, "Provenance") at the end:
   `gh release create v<version> --draft --title v<version> --notes-file <file>`.
   Never publish it; the person running you does.
7. Give the full chat report.
