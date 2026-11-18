## Summary

Shows a code span that the line wrap splits across two lines.

## Related issues

None

## Problem

None

## What changed

None

## Checks run

- Searched with `` grep '`[^`]*`' `` for spans.
- Ran `sh scripts/validate-report.sh --pr-body
  <file>` on this body, and `sh
  scripts/check-skills.sh <directory>`.

## Decisions and risks

None

## Notes for review

None

Assisted-by: Claude Code, claude-opus-5-5 (full implementation)
