---
name: draft-release
description: Draft the notes of a GitHub release, for the maintainer to create and publish. Use only when the maintainer asks for a release.
disable-model-invocation: true
---

# Draft a release

Tags and releases are the maintainer's (AGENTS.md, "Git"): you draft the
notes. This repository keeps no CHANGELOG.md; the release notes are its
changelog.

1. Check the branch, the working tree, and `HEAD`: on `main`, clean, and
   level with `origin/main`.
2. Tag and release title: both `v<MAJOR>.<MINOR>.<PATCH>`, as
   CONTRIBUTING.md, "Names", sets them. The maintainer chooses the version.
3. List the changes since the last tag:
   `git log --no-merges --format='%h %s' <last tag>..HEAD`.
4. Write the notes in Common Changelog form: `### Changed`, `### Added`,
   `### Removed`, `### Fixed`, in that order, each only when it has a change;
   one imperative line per change, citing its commit, and its pull request
   when there is one; no Unreleased section, and no version heading, since
   the release title carries the version. End with your trailer block
   (AGENTS.md, "Provenance").
5. Write them to a file outside the repository. Give the maintainer the
   command that creates the draft, and do not run it:
   `gh release create v<version> --draft --title v<version> --notes-file <file>`.
6. To revise the draft, give the maintainer
   `gh release edit v<version> --notes-file <file>`.
