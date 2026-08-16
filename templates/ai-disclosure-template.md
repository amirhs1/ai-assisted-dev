---
title: AI Use Disclosure — <PROJECT NAME>
version: v0.1.0
date: <YYYY-MM-DD>
covers: <release tag / commit range / manuscript>
prepared-by: <YOUR NAME>
orcid: <https://orcid.org/0000-0000-0000-0000>
accountable-for-content: <YOUR NAME>
governed-by: AI-POLICY.md v<X.Y.Z> # or an n/a form — see the note below
tools:
  - <tool> — <model id> (<YYYY-MM-DD>)
  - <tool> — <model id> (<YYYY-MM-DD>)
supersedes: <previous disclosure version | n/a>
---

<!--
Header fields, and why they are these fields.

A disclosure is a factual record about a bounded artifact,
and its header exists to make three things checkable without reading the body:
what it covers, who is accountable, and what was used.

  covers                   The artifact this disclosure is true of. A
                           disclosure with no bound is not a disclosure.
  accountable-for-content  The human answerable for every claim here,
                           including AI-assisted content. Usually the same
                           person as prepared-by; when it is not, say why in
                           section 5.
  orcid                    Optional. Delete the line if you do not have one.
  governed-by              The AI-POLICY.md version in force over `covers:`,
                           not the current one. If the policy changed mid-range,
                           name both versions and the date of the change.
                           This file is instantiated independently of the
                           others (guideline subsection 7.1), so it can be
                           needed where no policy file exists — a manuscript, a
                           deposit, a repository that runs no agent. Then name
                           the rules that were actually in force, in full and
                           without a link, and say the same in section 5:
                             n/a — no policy file; the rules in force were
                             <the README AI section | the AGENTS.md Do-not
                             list | the author's stated practice, <unwritten>>
                           Nested <> is pick-one-and-delete-the-rest; `|`
                           rather than `/` because the alternatives name files.
                           Where nothing was written down, keep the innermost
                           option and say so plainly rather than naming a file
                           to fill the field. Any of these is a legal value,
                           not an unfilled placeholder.
  tools                    One entry per tool: tool, model identifier, and a
                           date on which that identifier was in use. Separate
                           tool from identifier with an em dash, never a
                           comma. The date is an as-of anchor, not a start
                           date — it keeps a marketing name resolvable after
                           the model is retired; write `from <date>` only
                           where use genuinely began then. A product name
                           alone is not enough: the same name ships different
                           models over time. Periods, roles, and any
                           `not recorded` qualification belong in section 2,
                           which is authoritative. Where no identifier was
                           logged, write the product name and record
                           `not recorded` in section 2; do not guess.
  supersedes               The disclosure this one replaces, so the chain is
                           reconstructable. `n/a` for a first release.

If this disclosure accompanies a manuscript, the file is the repository
record; the submission still needs whatever statement the venue currently
requires. Placement and detail vary across publishers and may distinguish
writing assistance from AI used in the conduct of research (data, code,
analysis, figures, methodology). Check the venue at submission rather than
assuming this file satisfies it.

Delete every comment block before committing.
-->

# AI Use Disclosure — `<PROJECT NAME>`

Prepared around a conservative cross-venue baseline: **AI systems are not
credited as authors; substantive AI use affecting research or scholarly
judgement is recorded; accountable judgement remains human.** The submission
venue's current policy may require a different or more specific statement.

Scope of this disclosure: `<v1.2.0>` / commits `<abc123>..<def456>` /
`<manuscript title>`.

---

## 1. Summary statement

> Portions of this software and/or research workflow were developed with the
> assistance of generative AI tools (<tool names and model identifiers>). The
> named human author accepted the work under the review rules stated for this
> project and remains accountable for the claims and reported results. Any
> component not independently evaluable by the author is identified in
> section 5. Reference values and validation oracles are independently
> grounded; reported numerical results are traceable to their recorded
> computation or source. No AI system is credited as a human author.

_(Adjust the last sentence if it is not true. A narrower true statement is
worth more than a broad one that will not survive scrutiny.)_

---

## 2. Tools used

| Tool               | Version / model | Period              | Roles / extent                                      |
| ------------------ | --------------- | ------------------- | --------------------------------------------------- |
| <e.g. Claude Code> | <model id>      | <YYYY-MM – YYYY-MM> | plan, full implementation, review                   |
| <e.g. Copilot>     | <>              | <>                  | completion, partial implementation, copy-edit       |
| <e.g. chat tool>   | <>              | <>                  | literature support, analysis critique, figure draft |

<!--
Record the model name and version, not only the product name; the API model
string is preferred where known, and where only a marketing name was logged,
add the date the model was in use so the name stays resolvable after it is
retired. Where a session's model is unknown, write
`not recorded` in that cell rather than inferring it from the date. This template records the tool, model identifier, where it was used, and the
extent of human oversight. Model identity is worth recording at use time because
it may not be reconstructable later from the product name alone.
-->

---

## 3. Where assistance was used

| Component / artifact                      | Role / extent                          | Checks / human oversight                  |
| ----------------------------------------- | -------------------------------------- | ----------------------------------------- |
| `<path>`                                  | <full / partial implementation>        | <test ids, static checks, human review>   |
| `<analysis / data / figure>`              | <analysis support / generation / none> | <reference, reproduction, human decision> |
| `<manuscript / literature-support stage>` | <draft / copy-edit / critique>         | <sources opened, human review>            |
| <commit, PR, and release text>            | <>                                     | <>                                        |

<!--
Prose artifacts that are not files — commit messages, release notes, PR bodies
— belong here if a tool drafted them. For research, also record material AI
assistance to literature work, analysis, figures, or manuscript development at a
level that can be defended without inventing session-by-session precision.
-->

**Not AI-assisted:** `<paths>` — <why this matters, if it does>.

---

## 4. Ground truth, reported results, and protected inputs

State plainly which of the following hold. **An unchecked box here is a
recorded state, not an unfilled placeholder:** leave it unchecked and explain
it beneath the list. Do not delete a box to make the section look complete.

- [ ] All reference values and expected outputs in the test suite derive from
      <literature / analytic derivation / independent implementation>, cited in
      `<location>`.
- [ ] Where no independent reference existed, tests assert properties rather
      than values. Affected tests: `<list>`.
- [ ] Every numerical result reported in `<manuscript / report>` is traceable
      to a recorded computation or source that the author checked and accepted.
- [ ] Domain-level and methodological decisions — <observable definitions,
      error estimators, aggregation semantics, model choices> — were explicitly
      approved by the author rather than delegated to an AI system.
- [ ] Every external reference cited in `<paths>` was opened by the author and
      checked against the claim it supports before citation.
- [ ] Any AI-generated data used as study data is identified as such and is not
      treated as an independent validation oracle.
- [ ] No credentials, identifiable participant data, unpublished restricted
      material, embargoed results, or third-party material with incompatible
      terms were sent to an external AI service outside explicitly permitted
      provider/configuration and consent conditions.
- [ ] No generated passage known to reproduce an identifiable external source
      remains unattributed.

**Anything not checked above must be explained here:** <explanation>

---

## 5. Known limitations of this disclosure

Candor is the point of this section. Typical honest entries:

- Provenance trailers were adopted from `<commit / date>`; earlier history is
  not annotated and has **not** been reconstructed from memory.
- Model identifiers were not logged per session for `<period>`; the `tools:`
  header records the product name only for that range — and a product name
  whose model has since been retired may no longer resolve to anything
  specific.
- <No `AI-POLICY.md` governs `covers:`. The rules in force were <the README AI
  section | the `AGENTS.md` Do-not list | my stated practice, <unwritten>> —
  narrower than a policy file and unversioned, so a reader cannot establish
  which text was in force over <this range | this artifact>, nor check the
  claims above against it.>
- <Tool> completions used inline during editing are not individually recorded;
  the file records the defensible aggregate extent rather than reconstructed
  precision.
- <Subsystem> is Tier 1 (Delegated): it functions and is tested, but the author
  cannot independently evaluate its internals. It is excluded from any claim of
  research contribution.
- <This project has no independent reviewer; the accuracy of this disclosure
  rests on the named author alone.>
- <Some checks in `Checks-run:` were executed by an AI agent. The check output
  is recorded, but execution is not treated as independent verifier identity;
  human review and oracle independence are described above.>
- <Protected or restricted material was processed by <provider/configuration>
  under <agreement/consent basis>; scope and limitation: <...>.>
- <AI-assisted literature synthesis / conceptual reasoning / figure development
  cannot be reconstructed at session level; the aggregate role is recorded in
  section 3.>

---

## 6. Reproducing this disclosure

Where code generation/assistance was recorded by commit trailer, the record is
queryable:

```bash
git log --format='%h %s%n%(trailers:key=Assisted-by)%n%(trailers:key=Checks-run)%n%(trailers:key=Ground-truth-source)' <range>
```

This parses the trailer block structurally rather than matching text, so it
survives a squash-merge UI that reflows the commit body.

<!--
Delete the block above if this project's assistance is prose editing or non-code research assistance rather than
commit-attributed code generation. In that case there is no commit-level record by design, and the
file itself is the record — say so here in one line, and say why under section 5
rather than leaving the absence unexplained.
-->

---

## 7. Revision history

| Version | Date         | Change                          |
| ------- | ------------ | ------------------------------- |
| v0.1.0  | <YYYY-MM-DD> | Initial disclosure for `<tag>`. |
