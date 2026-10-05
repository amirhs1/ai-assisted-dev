---
name: open-issue
description: Open an issue that states a problem, its evidence, and the proposed change. Use when asked to file an issue.
---

<!--
Copy to .agents/skills/open-issue/SKILL.md; .claude/skills is a symlink to
.agents/skills. Replace the body format with the project's own issue template
if it has one. Fill every <...> or delete the line, and delete this comment.
-->

# Open an issue

1. Search for a duplicate first:
   `gh issue list --state all --search "<terms>"`.
2. Title: follow "Names" in AGENTS.md, "Git".
3. Body, in this order:
   - `## Problem`: what is wrong or missing, with evidence as `path:line`,
     `command → result`, or a link.
   - `## Solution`: the change proposed. Mark wording you drafted as a
     proposal.
   - `## Changes`: one checkbox per file:
     `- [ ] <path>, <section>: <change> (add | change | remove)`.
4. The reason comes from the person who asked, or from the evidence; never
   invent it. Include no secrets or personal data.
5. Open it with `gh issue create --title "<title>" --body-file <file>`, then
   give the full chat report.
