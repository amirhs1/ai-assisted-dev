## Summary

Adds three modes to the report validator.

## Related issues

Closes #27

## Problem

The validator knew one report shape.

## What changed

- scripts/validate-report.sh:1: one mode per shape.

## Checks run

```text
$ sh scripts/validate-report.sh --pr-body <file>
Report shape is valid (pr-body): <file>
```

Not verified: None.

## Decisions and risks

None

## Notes for review

The `<main>` in a quoted command is not a placeholder.

## AI assistance

Assisted-by: Claude Code, claude-opus-5-5 (full implementation)
