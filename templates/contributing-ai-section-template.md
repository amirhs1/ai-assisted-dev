<!--
CONTRIBUTING AI section — drop into CONTRIBUTING.md. Scope: AI-assisted
contributions only. Build setup, code style, and general contribution flow
belong to the rest of CONTRIBUTING.md.

TWO VARIANTS. Variant A assumes the repository carries AI-POLICY.md, and
points into it by rule ID. Variant B is for a repository under the minimal
adoption profile (guideline subsection 7.1) where the first external PR has
arrived before a policy file has: it states its rules in full and links to no
file the repository does not hold. Keep one, delete the other.

Rule IDs cited in variant A must be defined in the project's AI-POLICY.md.
Delete this comment block before committing.
-->

<!-- ===== VARIANT A — repository carries AI-POLICY.md ===== -->

## AI-assisted contributions

AI-assisted contributions are welcome, under the same standard applied to
everything else in this repository: the contributor can say why the change
exists, why it is correct, and what breaks without it.

1. **Disclose assistance in the PR description.** Tool plus model identifier
   and role/extent (for example, `full implementation`,
   `partial implementation`, `review`). If the exact model was not recorded,
   say `not recorded` rather than guessing. One sentence is enough. Commit
   trailers per `AI-POLICY.md` `[PROV-1]` are welcome but not required from
   outside contributors.
2. **The ground-truth rule binds contributors too.** A model may draft a test
   or run a check, but it may not supply the independent oracle that certifies
   its own implementation. Open and check cited sources yourself; where no
   independent reference exists, use a defensible property check — `[GT-1]`,
   `[GT-2]`, `[CITE-1]`.
3. **Do not weaken or delete a test to make a suite pass** (`[TEST-1]`). A diff
   changing an implementation and its own test together is blocked pending
   manual review (`[ENF-3]`); if an interface change genuinely forces the test
   to change, say so in the PR description.
4. **Unknown provenance is a verification question, not an accusation.** Where
   AI provenance is unknown, or where the change cannot be readily validated
   from its tests, references, and explanation, the maintainer may apply
   Supervised (T2)-level diff-reading rigor and treat test assertions as
   unverified until independently assessed. You may be asked to restate what
   the change does and why.
5. **Do not send protected project material to an external AI service without
   permission** (`[DATA-1]`). If provider handling, licence/contract terms, or
   required consent are unclear, do not send it.

Policy: [`AI-POLICY.md`](AI-POLICY.md). Per-release record:
[`AI-DISCLOSURE.md`](AI-DISCLOSURE.md).

---

---

<!-- ===== VARIANT B — minimal profile; no AI-POLICY.md in this repository =====
Self-contained by necessity: under the minimal profile the first external PR
can arrive before any policy file exists, and a link to a file the repository
does not hold is worse than no link. The five rules below are then the whole of
the standard for contributed work. -->

## AI-assisted contributions

AI-assisted contributions are welcome, under the same standard applied to
everything else here: the contributor can say why the change exists, why it is
correct, and what breaks without it.

1. **Disclose assistance in the PR description** — tool plus model identifier
   and role/extent. If the exact model was not recorded, say `not recorded`
   rather than guessing. One sentence is enough; commit trailers are welcome
   but not required from outside contributors.
2. **No circular ground truth.** A model may draft a test or run a check, but
   the oracle/reference that certifies its implementation must come from an
   independent basis you checked. Where no independent reference exists, use a
   defensible _property_ check. Any citation a model gave you is unverified
   until you have opened it and checked the claim it supports.
3. **Do not weaken or delete a test to make a suite pass.** A diff changing an
   implementation and its own test together is held for manual review; if an
   interface change genuinely forces the test to change, say so in the PR
   description.
4. **Unknown provenance is a verification question.** Where AI provenance is
   unknown, or the change cannot be readily validated from tests, references,
   and explanation, the maintainer may read it line by line and treat its test
   assertions as unverified until independently assessed.
5. **Do not send protected project material to an external AI service without
   permission.** If provider handling, licence/contract terms, or required
   consent are unclear, do not send it.

Agent instructions for this repository: [`AGENTS.md`](AGENTS.md).
