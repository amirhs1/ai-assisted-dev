# AGENTS.md — `<PROJECT NAME>`

<!--
Language-agnostic template. Audience: an AI coding agent, at the start of every
session.

TWO VARIANTS below — full and minimal. Keep one, delete the other; guideline
subsection 7.1 says which adoption profile gets which. The minimal variant is
the default for a solo-maintained repository.

Design rules for this file:
  1. SHORT. It is loaded every session and competes for context with the work.
     Target one screen of essentials; link out for the rest. The full variant
     is longer than that target because it must cover cases your project does
     not have: instantiating it means deleting sections, not keeping them.
  2. Non-obvious only. Do not restate what the agent can read from the code,
     the manifest, or the lockfile.
  3. Executable over descriptive. Commands beat prose.
  4. Canonical. If CLAUDE.md or similar also exists, one file is real and the
     other imports or points to it. For Claude Code, a CLAUDE.md shim may use
     `@AGENTS.md`. Never maintain duplicate rule sets by hand.
  5. One home per rule. Normative authority lives in AI-POLICY.md; every rule
     here is an operational one-liner plus a rule ID, never a second full
     statement. A line here that disagrees with the policy is a bug in this
     file.
  6. Cite rule IDs, never section numbers. `[GT-1]` survives a renumbering of
     AI-POLICY.md; `§4` does not. Every ID used below must be defined in the
     policy — a CI check can verify exactly that ([ENF-6]).
  7. Optional sections earn their context. Layout, vocabulary, and workflow detail
     stay only when they express a non-obvious constraint or have prevented a
     concrete class of mistakes.

Delete every comment block before committing.
-->

<!-- ============================ FULL VARIANT ============================ -->

## What is this project about

<Two sentences. What the project does and who uses it. Enough that the agent
does not guess wrong about intent.>

**Authority:** `AI-POLICY.md` governs what is permitted; this file is
operational one-liners and rule IDs pointing into it. Conflicts resolve in
favour of `AI-POLICY.md`, and this file is corrected.

---

## Commands

<!-- The single most valuable section. Exact, copy-pasteable, no placeholders. -->

| Purpose              | Command |
| -------------------- | ------- |
| Install / bootstrap  | `<>`    |
| Build                | `<>`    |
| Run all tests        | `<>`    |
| Run one test         | `<>`    |
| Lint                 | `<>`    |
| Type / static check  | `<>`    |
| Format               | `<>`    |
| Full pre-commit gate | `<>`    |

**Before proposing any change as complete, run the full gate above and report
the actual result.** Do not describe a change as working on the basis of
reading it.

---

## Layout

<!-- Map, not a listing. What each area OWNS, and what must not leak across. -->

```text
<root>/
  <dir>/     <what it owns; what it must not depend on>
  <dir>/     <>
  <dir>/     <>
  sandbox/   exploratory or unspecified work; never imported by src/, never merged directly
```

**Dependency rules:**

- `<A>` may depend on `<B>`; the reverse is a bug.
- `<>` is generated — do not hand-edit; regenerate with `<command>`.

---

## Vocabulary

<!--
Domain terms whose meaning here differs from their ordinary meaning. This
section prevents the most expensive failure mode: fluent code built on a wrong
model of the domain. If the project has a hierarchy, a lifecycle, or a unit
convention, it goes here.
-->

| Term     | Means here | Does _not_ mean |
| -------- | ---------- | --------------- |
| `<term>` | <>         | <>              |
| `<term>` | <>         | <>              |

<If the project has an ordered hierarchy or pipeline, state it explicitly:>

```text
<stage A> → <stage B> → <stage C>
```

<One line on what is legal to do at each stage and what is not.>

---

## Conventions a linter cannot express

- <e.g. errors are returned, never raised, below the API boundary>
- <e.g. all public entry points validate input; internals assume validated>
- <e.g. units are <unit> everywhere; conversion happens only at <boundary>>

---

## How to work here

1. **Explore before planning.** Read the relevant code and state what it does
   before proposing changes.
2. **Plan before coding** when the approach is uncertain, the change spans
   files, or the area is unfamiliar. Name the files that will change and what
   could break. Skip planning only for changes describable in one sentence.
3. **Implement only after acceptance criteria are explicit and maintainer-
   approved.** You may propose missing cases or ask questions; do not decide the
   success criteria yourself.
4. **Verify.** Run the gate. Report actual output, not expected output.
5. **Report honestly.** If something is unverified, say it is unverified.

**Scope discipline:** change only what was asked. Unrelated improvements are
proposed separately, never bundled into the diff.

---

## Do not

<!-- One-liners only. Full statements and rationale live in AI-POLICY.md under
the cited rule IDs; do not expand these into paragraphs. -->

- **Invent expected/reference values or domain invariants** that certify your
  own implementation (`[GT-1]`). No independent reference → propose a
  _property_ check and say that is what you did (`[GT-2]`).
- **Weaken or delete a test** to make a suite pass — report the failure
  (`[TEST-1]`). A diff touching an implementation and its own test together is
  blocked pending manual review (`[ENF-3]`); if an interface change genuinely
  forces it, say so in your report.
- **Invent the "why" of a change** — commit body, PR description, or
  changelog (`[WHY-1]`). Describe what changed. You may copy-edit a rationale
  the maintainer explicitly supplied, but do not add a new reason.
- **Fill `Ground-truth-source:` with a citation you were not given** (`[GT-1]`
  for the rule, `[PROV-1]` for the trailer). Write `n/a — property test` where
  true; otherwise leave the line for the maintainer.
- **Merge from or import `sandbox/`** — promotion to `src/` means a rewrite
  against stated criteria (`[PERM-9]`).
- **Decide**
  `<domain decisions — e.g. observable definitions, error estimators, aggregation semantics>`
  (`[DOM-1]`). Propose options; the decision is the maintainer's.
- **Add or upgrade a dependency** without asking (`[DEP-1]`).
- **Send protected material to an external service** unless the maintainer has
  explicitly confirmed that the provider configuration, agreement, and required
  consent permit it (`[DATA-1]`). If unsure, stop before sending.
- **Proceed with consequential T1 work** in `<security / privacy / safety /
  research-critical / production-critical paths>` without the competent
  independent human review required by `[RISK-1]` / `[REV-5]`.
- **Modify** `<generated paths>`, `<vendored paths>`, `<lockfiles>`, or any
  path outside your write scope (`[SCOPE-1]`).
- **Commit to `<protected branch>`** (`[BRANCH-1]`), run
  `<destructive commands>` unread (`[GIT-3]`), or touch workflows,
  `CODEOWNERS`, or repository settings (`[SCOPE-3]`, `[GIT-4]`). CI and
  workflow config you may draft for the maintainer to commit, never write
  directly (`[GIT-2]`).
- **Silently substitute an approach** when the requested one seems hard — say
  it seems hard and why.

---

## Commit format

```
<type>(<scope>): <subject>          <- you may draft

<what changed>                      <- you may draft
Why: TODO (maintainer)              <- do not invent; copy-edit only if the
                                       maintainer supplies the rationale

Assisted-by: <tool>, <model id> (<role / extent>)
Checks-run: <check actually run and result>
Ground-truth-source: <citation, or "n/a — property test">
```

Trailer scope and vocabulary: `[PROV-1]`–`[PROV-3]`. Operationally:
`Assisted-by:` records your actual model identifier and role/extent — use
`(full implementation)` when you generated essentially the whole implementation.
`Checks-run:` records only checks you actually executed this session and their
observed result; do not infer or reconstruct a result. Running a test does not
make you the independent verifier. `Why:` must originate with the maintainer (`[WHY-1]`). On
a squash-merged branch, trailers go on the squash commit.

---

## When stuck

<!-- Explicit fallbacks. Without these, an agent invents a path forward. -->

| Situation                                         | Do this                                                  |
| ------------------------------------------------- | -------------------------------------------------------- |
| Requirements ambiguous                            | Stop and ask. Do not pick an interpretation and proceed. |
| A test fails for reasons unrelated to your change | Report it; do not fix it in this diff.                   |
| The change is larger than expected                | Stop, report the revised scope, wait.                    |
| No obvious way to verify correctness              | Say so explicitly and propose a property-based check.    |
| Context is long and quality is degrading          | Say so and propose restarting with a written handoff.    |
| An external fact or API is needed                 | State that it is unverified rather than asserting it.    |
| Protected/restricted material may enter model context | Stop before sending; ask whether `[DATA-1]` permits it. |

---

## Pointers

- Policy, tier assignments, and every rule ID cited above: `AI-POLICY.md`
- Per-release disclosure: `AI-DISCLOSURE.md`
- Architecture / design notes: `<path>`
- Contribution guide: `<path>`

---

---

<!-- =========================== MINIMAL VARIANT ===========================
Default for a solo-maintained repository (guideline subsection 7.1). Where the
project carries no AI-POLICY.md, the Do-not list and the commit format below
are the whole of the rules, so they are written to stand alone and carry no
rule IDs — there is no file for an ID to point into.
-->

# AGENTS.md — `<PROJECT NAME>`

<What the project does, in one or two sentences.>

**Authority:** `AI-POLICY.md`, where this repository carries one; conflicts
resolve in its favour. Where it does not, the rules below are the policy.

## Commands

| Purpose              | Command |
| -------------------- | ------- |
| Install              | `<>`    |
| Run all tests        | `<>`    |
| Lint / check         | `<>`    |
| Full pre-commit gate | `<>`    |

Run the full gate before proposing any change as complete; report actual
output, not expected output.

## Do not

- Invent expected values or reference values: ground truth comes from the
  maintainer, cited literature, or an independent implementation. Where none
  exists, assert a _property_ and say that is what you did.
- Weaken or delete a test to make a suite pass; report the failure instead.
- Invent the "why" of a change — commit body, PR description, or changelog.
  Describe what changed; you may copy-edit a rationale the maintainer supplied.
- Send protected or restricted material to an external AI service unless the
  maintainer explicitly confirms the provider/configuration and permissions allow
  it.
- If the maintainer cannot independently evaluate security-, privacy-, safety-,
  research-critical-, or production-critical work, stop and require competent
  independent human review before it enters that path.
- Add or upgrade a dependency, commit to `<protected branch>`, or modify
  `<protected paths>` without asking.

## Commit format

```
<type>(<scope>): <subject>          <- you may draft

<what changed>                      <- you may draft
Why: TODO (maintainer)              <- do not invent; copy-edit only if supplied

Assisted-by: <tool>, <model id> (<role / extent>)
Checks-run: <check actually run and result>
Ground-truth-source: <citation, or "n/a — property test">
```

For the minimal profile, keep provenance lightweight: `Assisted-by:` on
AI-assisted behaviour-changing commits, with the real model id and role/extent;
`Checks-run:` on those commits with checks actually executed and their result;
`Ground-truth-source:` only when an expected/reference value is added or changed.
A model may execute a check, but may not manufacture the oracle that makes its
own implementation pass. Never backfill from memory; unknown provenance is
recorded as unknown. On a squash-merged branch, trailers go on the squash
commit.

## When stuck

Ambiguous requirements, growing scope, or no way to verify → stop, say so, and
ask. Never pick an interpretation and proceed silently; never state an
unverified external fact as verified.
