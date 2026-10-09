<!--
Two blocks. Paste the first into CONTRIBUTING.md. If the project already has
.github/pull_request_template.md, add the second block to its end. If it needs
a complete PR template, use pull-request-template.md instead; its closing
comment serves the same purpose. Keep the wording aligned with AI-POLICY.md.
Delete this comment before committing.
-->

<!-- ===== CONTRIBUTING.md ===== -->

## AI-assisted contributions

AI tools are welcome. Read the [AI policy](AI-POLICY.md) before opening a pull
request. The rules most often missed:

- Understand, and be able to explain, everything you submit.
- Say in the pull request which AI tools you used and for what.
- Write issues, pull request descriptions, and replies in your own words. If
  an AI agent writes them for you, you answer for every word, and its text
  ends with its `Assisted-by:` trailer, with `not recorded` for an unknown
  model.

Pull requests that don't follow the policy may be closed without review.

### Setup

- [ ] `.claude/settings.json` is committed with the attribution block.
- [ ] `git config core.hooksPath .githooks` has been run in this clone.
- [ ] `.gitmessage` is committed.
- [ ] `git config commit.template .gitmessage` has been run, for commits
      written in an editor.
- [ ] A test commit made by each tool in use ends with one trailer block that
      includes `Assisted-by:` and no AI `Co-authored-by:`
      (`git log -1 --format=%B`).
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

<!--
AI assistance: end the body with one trailer block, after a blank line. Write
one `Assisted-by: <tool>, <model id or not recorded> (<role>)` line for each
AI tool used, then `Checks-run: <check actually run> — <observed result>` for
each check it ran. Do not guess a model; write `not recorded`. With no AI
tool, leave the block out. Do not include prompts, secrets, or personal data.
-->
