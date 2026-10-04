<!--
AI-DISCLOSURE.md template — research projects only. Keep a separate
disclosure for each release, manuscript, or deposit that must account for AI
use, either as a named file or in a tagged release snapshot. Ordinary software
releases rely on commit trailers and pull-request descriptions instead.

This file is the repository record. A manuscript still needs whatever
statement the venue currently requires, and venues may treat writing
assistance differently from AI used in the research itself. Check the venue's
policy at submission rather than assuming this file satisfies it.

Fill every <...> or delete the line. In section 4 an unchecked box is a
recorded state, not a placeholder: leave it unchecked and explain it. Delete
every comment before committing.
-->

# AI Use Disclosure — `<PROJECT NAME>`

- **Covers:** <release tag | manuscript title | deposit identifier>
- **Repository revision:** <full commit SHA or tag, with repository location>
- **History queried:** <commit range | no commit-level record>
- **Date:** <YYYY-MM-DD>
- **Prepared by:** <NAME> <(ORCID)>
- **Accountable for content:** <NAME>
- **Rules in force:** <`AI-POLICY.md` as of <YYYY-MM-DD> | the README AI
  section | my stated practice, not written down>
- **Replaces:** <previous disclosure | none>

AI systems are not credited as authors. Substantive AI use that affects the
research is recorded here, and accountable judgement remains human.

## 1. Summary

> Portions of this software and/or research workflow were developed with the
> assistance of generative AI tools (<tool names and model identifiers>). The
> named author accepted the work under the review stated for each component in
> section 3 and remains accountable for the claims and reported results.
> Components the author cannot evaluate independently are marked Delegated.
> Reference values and validation oracles are independently grounded; reported
> numerical results are traceable to their recorded computation or source.

_(Adjust any sentence that is not true. A narrower true statement is worth more
than a broad one that will not survive scrutiny.)_

## 2. Tools used

| Tool   | Model      | In use as of | Roles                               |
| ------ | ---------- | ------------ | ----------------------------------- |
| <tool> | <model id> | <YYYY-MM-DD> | <plan, full implementation, review> |

<!-- Record the model identifier, not only the product name: the same product
ships different models over time, and the date keeps a model name resolvable
after it is retired. Where the model was not logged, write `not recorded`; do
not infer it from the date. -->

## 3. Where assistance was used

Tiers, as in the README:

- **Instrumented** — the author could write it; AI reviewed, refactored, or
  proposed alternatives.
- **Supervised** — AI drafted; the author read every line and set the
  acceptance criteria and test values.
- **Delegated** — AI generated; the author cannot fully evaluate it. It is
  covered by tests, kept isolated and low-risk, and not presented as the
  author's work.

| Component                    | Tier   | Role / extent                   | Checks / human oversight                  | Record               |
| ---------------------------- | ------ | ------------------------------- | ----------------------------------------- | -------------------- |
| `<path>`                     | <tier> | <full / partial implementation> | <test ids, static checks, human review>   | <commit SHA or PR>   |
| `<analysis / data / figure>` | <tier> | <analysis support / generation> | <reference, reproduction, human decision> | <file or workflow>   |
| `<manuscript stage>`         | —      | <draft / copy-edit / critique>  | <sources opened, human review>            | <section or file>    |
| <commit, PR, release text>   | —      | <>                              | <>                                        | <commit, PR or file> |

<!-- Copy the tiers from the README table as it stood at this release. Tiers
apply to code and analysis; write — for prose rows. -->

**Not AI-assisted:** `<paths>` — <why this matters, if it does>.

## 4. Ground truth, reported results, and protected inputs

State plainly which of the following hold.

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

**Anything not checked above is explained here:** <explanation>

## 5. Known limitations

Typical honest entries; keep the ones that apply.

- Provenance trailers were adopted from `<commit / date>`; earlier history is
  not annotated and has **not** been reconstructed from memory.
- Model identifiers were not logged for `<period>`; section 2 records
  `not recorded` for that range.
- <Tool> completions used inline while editing are not individually recorded;
  section 3 gives the aggregate extent.
- <Component> is Delegated: it works and is tested, but the author cannot
  evaluate its internals, and it is excluded from any claim of research
  contribution.
- <No rules were written down for this period; the practice described here is
  the author's own account.>
- <This project has no independent reviewer; the accuracy of this disclosure
  rests on the named author alone.>
- <Protected or restricted material was processed by <provider/configuration>
  under <agreement/consent basis>; scope and limitation: <...>.>

## 6. Reproducing this disclosure

Where assistance was recorded by commit trailer, query the range identified
above:

```bash
git log --format='%h %s%n%(trailers:key=Assisted-by)%n%(trailers:key=Ground-truth-source)' <range>
```

This query reads trailers in commits that remain in the selected history. A
squash merge creates a new commit: inspect its final message and retain or
restore the relevant trailers there. If individual commit details were lost,
identify the pull request or another surviving record in section 3 and explain
the gap in section 5. An absent trailer alone does not establish that no AI was
used. Prose or other non-code assistance may instead be recorded by file and
release; describe that record and its limits here.

## 7. Revision history

| Date         | Change                          |
| ------------ | ------------------------------- |
| <YYYY-MM-DD> | Initial disclosure for `<tag>`. |
