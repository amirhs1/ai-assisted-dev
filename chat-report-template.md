<!--
Chat report template. Audience: an AI agent reporting back, in chat, to the
person running it. Copy both forms where the agent reads them: a report skill,
or AGENTS.md. Delete this comment before committing.

Use the full form when the session changed a file, opened or updated a pull
request or issue, or needs a decision; otherwise the short form. Posting a
comment gets the short form. The shape is fixed: a section that does not apply
says `None` and is never dropped. The verdict appears once, at the top.
-->

# Chat report

## Short form

```text
<Answer in one or two sentences.>
Based on: <files read or commands run; "memory only" if nothing was checked>
Open: <anything unverified, or None>
```

## Full form

```text
## <title>
**Verdict: COMPLETE | NOT COMPLETE — <one line; anything remaining goes here>**
**End product:** <code change | design | issue #n | PR #n | decision for you> — <path or link>

1 What changed — files as path:line, or the issue or PR created
2 Checks run — command → result; anything not run → why
3 Decisions I made that were yours — choice, rejected alternative, cost to reverse
4 What I need from you — Action Needed / Decision Needed, blocking items first; or None
5 Close-out — what to review, branch state, what to keep
```
