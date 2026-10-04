---
name: post-comment
description: Post a short comment on an issue or pull request. Use when asked to reply or comment.
---

# Post a comment

Post one only when the maintainer asks (AGENTS.md, "Git").

1. Comment only on the issue or pull request the maintainer named.
2. Write the comment in this shape:

   ```text
   <Answer in one or two sentences.>
   Based on: <files read or commands run>
   Open: <anything unverified, or None>
   ```

3. Cite evidence as `path:line` or `command → result`. Include no secrets,
   personal data, or anything from a private repository.
4. Post it with `gh issue comment <n> --body-file <file>` or
   `gh pr comment <n> --body-file <file>`, then give the short chat report.
