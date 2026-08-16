<!--
README AI section — drop into README.md, near the bottom, above Licence.
Keep it to a screen. Detail belongs in AI-POLICY.md; per-release specifics
belong in AI-DISCLOSURE.md. Three variants below — use one, delete the rest.
-->

## AI-assisted development

This project is developed with generative AI coding tools under an explicit
policy: **[`AI-POLICY.md`](AI-POLICY.md)**.

Ownership here is treated as a verification property rather than a typing
credit: in Supervised and Instrumented subsystems, the author can say for any
line why it exists, why it is correct, and what breaks without it — regardless
of what produced the text. Delegated subsystems are the stated exception:
functional and tested, but not independently evaluated, and not presented as a
contribution.

Path-specific tier assignments live in `AI-POLICY.md`, which is the single
authoritative table so the README cannot drift from it. If any Delegated (T1)
area materially affects users or research results, summarise that exception
here and apply `[RISK-1]`: `<none | short list of material T1 areas>`.

**Standing constraint:** validation oracles are independently grounded
(`[GT-1]`), reported results remain traceable to their computation/source
(`[NUM-1]`), and consequential work that the maintainer cannot evaluate
requires competent independent human review (`[RISK-1]`). Per-release or
manuscript detail is in [`AI-DISCLOSURE.md`](AI-DISCLOSURE.md).

Agent-facing instructions: [`AGENTS.md`](AGENTS.md).

---

---

<!-- VARIANT B — minimal, for a small or personal project. Under the minimal
adoption profile (guideline subsection 7.1), where the repository carries no
AI-POLICY.md, delete the policy link below: the statements in this variant are
then the policy, and a link to a file the repository does not hold is
worse than no link. -->

## AI-assisted development

Parts of this repository were generated or edited with generative AI coding
tools. Behaviour-changing work is checked and accepted by the maintainer; any
area the maintainer cannot independently evaluate is treated as Delegated and
kept low-consequence or independently reviewed. Policy:
[`AI-POLICY.md`](AI-POLICY.md). Agent instructions: [`AGENTS.md`](AGENTS.md).

Validation oracles are independently grounded, and reported results are
traceable to their recorded computation or source.

---

---

<!-- VARIANT C — for a project you are honest about not fully owning -->

## AI-assisted development

This project was built with substantial generative AI assistance in a domain
where I am not (yet) an independent evaluator. It works and is checked, but I
would not present its internals as my engineering contribution. Consequential
security-, privacy-, safety-, research-, or production-critical work is
excluded from ordinary Delegated review or receives competent independent human
review — see [`AI-POLICY.md`](AI-POLICY.md).

I am recording this rather than eliding it, because an unstated dependency is
worse than a stated one.
