<!--
AGENTS.md template. Audience: an AI coding agent, reading it at the start of
every session. Copy to AGENTS.md, fill every <...> or delete the line, delete
the optional sections that don't apply, and delete every comment before
committing.

Design rules:
  1. Short. This file is loaded every session and competes for context with
     the work. Link out for detail.
  2. Non-obvious only. Don't restate what the agent can read from the code,
     the manifest, or the lockfile.
  3. Executable over descriptive. Commands beat prose.
  4. Self-contained. Every rule the agent must follow is written here in full.
     Other files may be named as further reading, never as the only place a
     rule lives.
  5. One real file. If other AI-coding agent files (e.g., CLAUDE.md) exist,
     they import this one (`@AGENTS.md`) and add only tool-specific facts.
-->

# AGENTS.md — `<PROJECT NAME>`

<What the project does and who uses it, in two sentences — enough that you
don't guess wrong about intent.>

## Commands

| Purpose              | Command |
| -------------------- | ------- |
| Install              | `<>`    |
| Build                | `<>`    |
| Run all tests        | `<>`    |
| Run one test         | `<>`    |
| Lint / format        | `<>`    |
| Full pre-commit gate | `<>`    |

Run the full gate before calling a change complete, and report the actual
output, not the expected output. Do not describe a change as working because it
reads correctly.

<!-- Optional. Keep only if it states ownership or a boundary the code does
not make obvious. -->

## Layout

```text
<root>/
  <dir>/    <what it owns; what it must not depend on>
  <dir>/    <>
```

- `<A>` may depend on `<B>`; the reverse is a bug.
- `<path>` is generated — regenerate it with `<command>`; never hand-edit it.

<!-- Optional. Terms whose meaning here differs from their ordinary meaning. -->

## Vocabulary

| Term     | Means here | Does _not_ mean |
| -------- | ---------- | --------------- |
| `<term>` | <>         | <>              |

<!-- Optional. -->

## Conventions a linter cannot express

- <e.g. units are <unit> everywhere; conversion happens only at <boundary>>

## Where you may write

<!-- Repeats the tier table in the README's AI section, with the agent's role
in each tier. Change both in the same commit. -->

| Path                           | Tier         | Your role                                                                        |
| ------------------------------ | ------------ | -------------------------------------------------------------------------------- |
| `<src/core/>`                  | Instrumented | Review, refactor, propose alternatives. Do not write first drafts of core logic. |
| `<src/io/>`, `tests/`, `docs/` | Supervised   | Draft against acceptance criteria the maintainer set. Expect every line read.    |
| `<scripts/>`                   | Delegated    | Generate, keeping the change isolated. Explain what it will do before making it. |

- A path not listed is Supervised. Work that touches security, credentials,
  private data, or published results is never Delegated, whatever the table
  says.
- Apply only wording the maintainer supplies: `AI-POLICY.md`,
  `<other governing prose>`.
- Never edit these; draft a change for the maintainer instead:
  `.github/workflows/`, `CODEOWNERS`, `<generated or vendored paths>`,
  `<lockfiles>`.

## How to work here

1. Read the relevant code and say what it does before proposing a change.
2. Plan first when the change spans files or the approach is uncertain: name
   the files that will change and what could break.
3. Implement only against acceptance criteria the maintainer has approved. You
   may propose criteria or ask; do not decide them.
4. Change only what was asked. Propose unrelated improvements separately.

## Do not

- Invent a reference value, expected output, or domain invariant that certifies
  your own implementation. Reference values come from a derivation, the
  literature, measured data, or an independent implementation. If none exists,
  test a property (symmetry, conservation, invariance) and say that is what you
  did.
- Weaken or delete a test to make a suite pass. Report the failure instead.
- Report a number that does not trace back to code that actually ran or to a
  source the maintainer checked.
- Present a citation as verified. A reference you suggest is a lead until the
  maintainer has checked it.
- Invent the reason for a change in a commit, pull request, or changelog.
  Describe what changed; copy-edit a reason only if the maintainer gave one.
- Decide <domain choices, e.g. observables, estimators, fitting ranges>.
  Propose options; the maintainer decides.
- Add or upgrade a dependency without asking.
- Send credentials, private or restricted data, or material the maintainer has
  not cleared to an external service.
- Substitute an easier approach for the one requested without saying so. If it
  seems hard, say why.

## Git

- <Which git actions need the maintainer's approval here — e.g. "ask before
  staging, committing, and pushing", or "you may commit and push to a topic
  branch; never to `<main>`".>
- Show any history-rewriting command (rebase, amend, squash) before running it.
- Each commit lands on `<main>` unchanged; keep it coherent.
- Never force-push, delete tags or releases, or change branch protection,
  repository settings, or secrets.
- Open issues or pull requests, or post comments, only when the maintainer
  asks.

## Commit format

Use the `.gitmessage` as commit template if it is defined in the repo;
otherwise, use the following:

<!-- Adjust the first line to the project's commit convention. -->

```text
<type>(<scope>): <subject>

<what changed>

Why: <reason supplied by the maintainer; omit for a trivial change>

Assisted-by: <tool>, <model identifier or not recorded> (<role or extent>)
Checks-run: <check actually run> — <observed result>
Ground-truth-source: <independent source of a reference value>
```

- Write the subject and what changed. Add the reason only if the maintainer
  gave you one; otherwise leave it out or ask. Never write a placeholder.
- All trailers sit in one final paragraph, one per line, with no blank line
  between them and nothing after them. `Why:` stays in the body above it.
- `Assisted-by:` names your actual model and role. Use `(full implementation)`
  when you wrote essentially all of it. If you don't know the model, write
  `not recorded`; never guess or fill it in later from memory.
- Add `Ground-truth-source:` only when the commit adds or changes a reference
  value. Omit it for a property test without a reference value.
- <Optional: `Checks-run: <check> — <result>` for checks actually run that CI
  does not record. Omit it otherwise. Running a check is not independent
  verification.>
- Do not add a `Co-authored-by:` line for an AI tool; write `Assisted-by:`
  instead.
- If the `commit-msg` hook rejects a commit, fix the message. Never use
  `--no-verify`.

## When stuck

| Situation                                         | Do this                                                  |
| ------------------------------------------------- | -------------------------------------------------------- |
| Requirements are ambiguous                        | Stop and ask. Do not pick an interpretation and proceed. |
| A test fails for reasons unrelated to your change | Report it; do not fix it in this change.                 |
| The change is growing beyond what was asked       | Stop, report the new scope, and wait.                    |
| No obvious way to verify correctness              | Say so and propose a property-based check.               |
| An external fact or API is needed                 | Say it is unverified rather than asserting it.           |
| Restricted material might enter your context      | Stop before sending it, and ask.                         |
| Context is long and quality is degrading          | Say so and propose restarting from a written handoff.    |

<!-- Optional. -->

Further reading: <`AI-POLICY.md` (rules for contributors)>, <architecture
notes: `<path>`>.
