## Summary

<!-- A comment on one line. --> then <reported 1>.

## Related issues

None

## Problem

A `<!--` in a code span opens no comment, so <reported 2> is still
reported, and `-->` closes nothing.

## What changed

<!-- A comment holds <skipped>,

a blank line, and <skipped>. --> then <reported 3>.

## Checks run

<!-- A comment over
two lines. --> then <reported 4>.

## Decisions and risks

<!-- A comment holds a fenced block,

```text
<skipped>
```

and <skipped>. --> then <reported 5>.

## Notes for review

None

Assisted-by: Claude Code, claude-opus-5-5 (full implementation)
