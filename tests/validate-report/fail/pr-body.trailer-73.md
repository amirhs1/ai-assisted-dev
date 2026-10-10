## Summary

Adds a length limit for trailer lines.

## Related issues

None

## Problem

A trailer line over 72 characters breaks in the merge commit.

## What changed

- scripts/validate-report.sh: the trailer line length.

## Checks run

- `sh scripts/validate-report.sh --pr-body body.md` → `Report shape is valid (pr-body): body.md`

Not verified: None.

## Decisions and risks

None

## Notes for review

The last trailer line holds 73 characters, one of them an em dash; the one before it is within the limit.

Assisted-by: Claude Code, claude-opus-5-5 (full implementation)
Checks-run: sh scripts/check-repo.sh — All checks passed.
Checks-run: sh scripts/validate-report.sh --pr-body on this body — valid.
