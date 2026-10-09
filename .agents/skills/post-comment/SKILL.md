---
name: post-comment
description: Post a short comment on an issue or pull request. Use when asked to reply to or comment on an issue or pull request, not for comments in code.
---

# Post a comment

1. Comment only on the issue or pull request the maintainer named.
2. Give the answer first, with evidence as `path:line` or `command → result`.
   Include no secrets, personal data, or anything from a private repository.
   End with your trailer block (AGENTS.md, "Provenance").
3. Post it with `gh issue comment <n> --body-file <file>` or
   `gh pr comment <n> --body-file <file>`.
