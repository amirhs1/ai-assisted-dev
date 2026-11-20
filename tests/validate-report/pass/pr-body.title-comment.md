<!--
Copy to .github/pull_request_template.md. This is the pull request's full
report. Keep every section, in this order, then the trailer block; a section
that does not apply says `None`. Remove any prompts that do not apply to the
project.
-->

<!-- Title: as CONTRIBUTING.md, "Names", sets it. -->

## Summary

Skips HTML comments in the report validator.

## Related issues

Closes #103

## Problem

A body that kept the template's title comment was rejected.

## What changed

- scripts/validate-report.sh:1: a comment is not a placeholder.

## Checks run

sh scripts/check-repo.sh → All checks passed.

Not verified: None.

## Decisions and risks

None

## Notes for review

None

<!--
AI assistance: end the body with one trailer block, after a blank line. Write
one `Assisted-by: <tool>, <model id or not recorded> (<role>)` line for each
AI tool used, then `Checks-run: <check actually run> — <observed result>` for
each check it ran. Do not guess a model; write `not recorded`. With no AI
tool, leave the block out. Do not include prompts, secrets, or personal data.
Responsibility for the contribution remains with the contributor; see
`AI-POLICY.md` where that policy exists.
-->

Assisted-by: Claude Code, claude-opus-5-5 (full implementation)
Checks-run: sh scripts/check-repo.sh — All checks passed.
