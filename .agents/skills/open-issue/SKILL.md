---
name: open-issue
description: Open an issue that states a problem, its evidence, and the proposed change. Use when asked to file an issue.
---

# Open an issue

Open one only when the maintainer asks (AGENTS.md, "Git").

1. Search for a duplicate first:
   `gh issue list --state all --search "<terms>"`.
2. Title: the change wanted, in the imperative.
3. Body, in this order:
   - `## Problem`: what is wrong or missing, with evidence as `path:line`,
     `command → result`, or a link.
   - `## Solution`: the change proposed. Mark wording you drafted as a
     proposal.
   - `## Changes`: one checkbox per file:
     `- [ ] <path>, <section>: <change> (add | change | remove)`.
   - When it applies, end with "Guideline and kit changes are tracked
     separately."
4. The reason comes from the maintainer, or from the evidence; never invent
   it. Include no secrets, personal data, or anything from a private
   repository.
5. Label it `documentation`, `enhancement`, or `bug`.
6. Open it with
   `gh issue create --title "<title>" --label <label> --body-file <file>`,
   then give the full chat report.
