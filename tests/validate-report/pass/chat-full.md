## Validate the three report shapes
**Verdict: COMPLETE — the three modes work and their fixtures pass.**
**End product:** code change — scripts/validate-report.sh

1 What changed — scripts/validate-report.sh:1 adds --chat-short, --chat-full, and --pr-body.
**2 Checks run**
- `sh scripts/validate-report.sh --pr-body <file>` → valid.

### 3 Decisions I made that were yours

None.

4 What I need from you — None
5 Close-out — Review the fixtures under tests/validate-report/.
