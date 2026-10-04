<!--
Two blocks. Paste the first into CONTRIBUTING.md. If the project already has
.github/pull_request_template.md, add the second block to its end. If it needs
a complete PR template, use pull-request-template.md instead; its AI section
serves the same purpose. Keep the wording aligned with AI-POLICY.md. Delete
this comment before committing.
-->

<!-- ===== CONTRIBUTING.md ===== -->

## AI-assisted contributions

AI tools are welcome. Read the [AI policy](AI-POLICY.md) before opening a pull
request. The rules most often missed:

- Understand, and be able to explain, everything you submit.
- Say in the pull request which AI tools you used and for what.
- Write issues, pull request descriptions, and replies in your own words.

Pull requests that don't follow the policy may be closed without review.

### Setup

- [ ] `.claude/settings.json` is committed with the attribution block.
- [ ] `git config core.hooksPath .githooks` has been run in this clone.
- [ ] `git config commit.template .gitmessage` has been run, for commits
      written in an editor.
- [ ] A test commit made by each tool in use ends with `Assisted-by:` and no
      AI `Co-authored-by:` (`git log -1 --format=%B`).
- [ ] `.gitignore` has the agent-files block:

  ```gitignore
  # Agent files: local only
  CLAUDE.local.md
  AGENTS.local.md
  .claude/settings.local.json
  .claude/worktrees/
  .claude/.cc-writes/
  ```

<!-- ===== .github/pull_request_template.md ===== -->

## AI assistance

Write `None`, or name each AI tool you used (with the model, if known) and what
it did — for example, "<tool> (<model>): drafted the parser and its tests; I
rewrote the error handling and reviewed every line." If you don't know the
model, write `not recorded`. Then copy the branch's `Assisted-by:` lines from
`git log --no-merges --format=%B <main>..HEAD | grep '^Assisted-by:'`.
