---
name: open-issue
description: Open an issue that states a problem, its evidence, and the proposed change. Use when asked to file an issue; not for a suspected vulnerability or a reply on an existing issue.
---

# Open an issue

1. A suspected vulnerability never goes into a public issue: stop and tell
   the maintainer.
2. Search for a duplicate first:
   `gh issue list --state all --search "<terms>"`.
3. Title: follow "Names" in CONTRIBUTING.md.
4. Body, in this order:
   - `## Problem`: what is wrong or missing, with evidence as `path:line`,
     `command → result`, or a link.
   - `## Solution`: the change proposed. Mark wording you drafted as a
     proposal.
   - `## Changes`: one checkbox per file:
     `- [ ] <path>, <section>: <change> (add | change | remove)`.
   - When it applies, "Guideline and kit changes are tracked separately."
   - Last, your trailer block (AGENTS.md, "Provenance").
5. The reason comes only from the maintainer or from the source of the
   evidence; never invent it. Include no secrets, personal data, or anything
   from a private repository.
6. Labels, from "Names": one `type:` label for the type that fits the work,
   and an `area:` label for each area it changes.
7. Open it with
   `gh issue create --title "<title>" --label <labels> --body-file <file>`.
