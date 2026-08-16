---
title: AI-Assisted Development Guideline
version: v0.1.0
date: 2026-08-15
status: Living document — expect revision
owner: Amir Sadeghi
applies-to:
  software repositories maintained by the owner; AI-assisted research conducted
  by the owner
review-cadence: quarterly, or immediately on any tier change
license: CC BY 4.0 (this guideline); templates/ dedicated under CC0 1.0
---

# AI-Assisted Development Guideline

A working guideline for using generative AI tools in software development and
research while retaining human agency, accountable judgement, and a verifiable
record of how software and research artifacts were produced.

This document is **normative for me** and **descriptive for others**. It is not
a claim that this is the correct way to work; it is a record of the way I have
decided to work, the reasoning behind it, and the evidence that reasoning rests
on — so that both the decisions and their justification can be revised as the
evidence changes.

## Quick start

For a solo repository that runs a coding agent, start with the **minimal
profile** in subsection 7.1 and add documents only when their trigger becomes
live. For research software, collaboration, or a release/manuscript that must
account for AI use, instantiate the relevant full-profile documents.

Before implementation:

1. Assign the affected subsystem T1, T2, or T3; consequential work cannot use
   ordinary T1 review.
2. Finalize and approve the acceptance criteria. The model may suggest missing
   cases, but the human decides what counts as success.
3. Establish an independent oracle, reference, property, or other falsifiable
   check, and keep protected material out of external model context unless its
   use is explicitly permitted.

Before merge or publication: run the applicable checks, complete the human
review required by the tier, record AI provenance without reconstructing what
was not logged, and check any submission venue's current disclosure rule.

---

## 1. Core principle: ownership is a verification property

The distinction between "vibe coding" and owned engineering is **not** how much
of the text a model produced. It is whether the author can independently answer
three questions about any line in the repository:

1. **Why does this exist?** — recoverable from an issue, a test, a docstring,
   or a commit message. Not from memory.
2. **Why is it correct?** — some check other than "it ran without raising."
3. **What breaks if I delete it?** — a named test fails, or a named consequence
   follows.

**If all three are answerable, model-generated code can be owned code.** **If
they are not, hand-typed code is still vibe coding — just slower.**

T1 (Delegated) subsystems are the stated exception: they are code where the
three questions are _not_ answerable, kept deliberately and declared as such
(section 3). The criterion is not weakened by that exception; the exception is
what keeps the criterion honest instead of aspirational.

This is deliberately a _testable_ criterion rather than a stance. It can be
applied to a diff at review time, and it does not require tracking who typed
what. For non-code research artifacts, apply the same logic at the artifact or
claim level: why it exists, what evidence supports it, and what would change if
it were removed.

### 1.1 Corollary

Ownership is therefore something _built with infrastructure_, not something
preserved by abstaining. Abstaining from AI tools in a repository with no tests
does not produce ownership; it produces unverified code with a human author.

---

## 2. Evidence base

The empirical picture as of mid-2026 is **mixed and contested**. Any guideline
that cites only one side of it is doing advocacy. Both sides below are recorded
so that this document can be argued with.

### 2.1 Findings that caution against optimism

- **METR randomized controlled trial (Becker et al., 2025).** 16 experienced
  open-source developers, 246 real tasks, in repositories they had contributed
  to for ~5 years on average. Measured result: **19% _slower_** with AI tools
  available. Forecast beforehand: 24% _faster_. Self-assessment afterwards: 20%
  _faster_. _Caveats, which matter:_ small n; mature repositories with deep
  prior familiarity; and early-2025 tooling (primarily Cursor Pro with Claude
  3.5/3.7 Sonnet). A separate follow-up experiment begun in August 2025 became
  difficult to interpret because wider AI adoption created substantial
  participant- and task-selection effects, along with timing complications for
  concurrent agents; METR changed that follow-up design.[^18] This does not
  retract the early-2025 RCT, but METR now describes the original result as a
  historical snapshot rather than an estimate of current AI effects. _What
  survives the caveats:_ the **perception–measurement gap** in that setting.
  Self-reported AI productivity was confidently and substantially wrong in the
  direction of optimism.[^1]

- **Code churn and duplication (Harding and Kloster, 2024).** Longitudinal
  analysis of ~153M changed lines projected a doubling of code churn — lines
  reverted or rewritten within two weeks — alongside a shift toward _added_ and
  _copy/pasted_ operations at the expense of _updated_ and _moved_. The authors
  interpret the pattern as evidence of less refactoring and more duplication;
  the observational design supports the trend, not a causal estimate of AI's
  effect.[^2]

- **DORA 2024, delivery stability.** Delivery-stability _losses_ alongside the
  code-quality gains recorded in subsection 2.2 (~-7.2% per 25% increase in AI
  adoption — a conditional estimate, not an absolute drop).[^5] Consistent with
  the hypothesis that AI improves **micro-quality** (the individual function)
  while degrading **system-level properties** (integration, stability, change
  failure rate).[^17] The split is the finding: one study running in both
  directions, which is why it is recorded in both subsections rather than filed
  under either.

- **Security (Pearce et al., 2021).** Across 89 deliberately security-relevant
  scenarios, many drawn from MITRE's Top 25 CWE list, roughly 40% of
  Copilot-generated programs were vulnerable. _Caveats, which matter:_ this
  evaluates Codex-era Copilot in 2021; the scenarios were constructed to elicit
  weaknesses rather than sampled from real work, so the rate is a property of
  that prompt set and model generation as much as of software development
  generally. _What survives the caveats:_ the failure mode, not the rate. The
  result is consistent with a code model learning and reproducing insecure
  coding patterns present in its training distribution. Newer models may reduce
  this failure mode; the study does not establish that it is invariant across
  model generations.[^3]

- **AI-introduced technical debt in the wild (Liu et al., 2026 preprint).** A
  static-analysis study of 304,362 commits explicitly attributed to AI coding
  assistants across 6,275 GitHub repositories and five coding assistants
  identified 484,606 introduced issues; more than 15% of commits from every
  assistant introduced at least one detected issue, and 24.2% of tracked
  AI-introduced issues remained at the latest repository revision. This is
  large-scale real-world evidence, but it remains a preprint and its findings
  inherit the limits of static-analysis rules and explicit commit-attribution
  metadata.[^19]

### 2.2 Findings that caution against pessimism

- **GitHub RCT (Bauer, 2024), n=202.** Small but statistically significant
  improvements in readability, reliability, maintainability, and conciseness of
  AI-assisted code. Caveats: the study evaluated GitHub's own product and a
  constrained Python web-server task rather than sustained work in a mature
  repository.[^4]

- **DORA 2024, code quality.** Code-quality _gains_ at the level of the
  individual change.[^5] Its delivery-stability finding runs the other way and
  is recorded in subsection 2.1; neither half is quotable without the other.

- **DORA 2025** (nearly 5,000 respondents). AI adoption is associated with
  _higher_ software-delivery throughput — a reversal of the 2024 throughput
  association — while delivery instability still increases. About 90% of
  respondents use AI, more than 80% report perceived productivity gains, and
  ~30% report little or no trust in AI-generated code.[^6]

### 2.3 Synthesis

**Operational synthesis:** DORA's 2025 finding is that AI acts as an amplifier
of the engineering and organizational system around it.[^6] For this guideline,
the relevant part of that system is **verification infrastructure**: tests,
static checks, CI, reviewable diffs, traceable references, and fast feedback.
This narrower formulation is my operational interpretation, not DORA's measured
construct.

Two operational consequences:

1. **Do not trust felt productivity.** It is the one thing measured to be
   unreliable. Where a claim about AI's effect on a project appears in any of
   its records — its policy, its disclosure, its working notes — it should rest
   on something observable (test failures caught, churn, review time), not on
   how a session felt. This holds for every project governed by this guideline,
   including the repository that holds the guideline itself.
2. **Invest in checkability before throughput.** Establish the checks that can
   falsify a change — tests, static analysis, reference comparisons, or
   explicit review gates — before expanding agent autonomy. This is a design
   principle derived from the evidence above, not a universal causal result
   established by any one study.

---

## 3. The tier model

The honest variable is not the tool and not the language. It is **whether I can
evaluate the output**.

| Tier                  | My position                                | AI's role                 | Obligations                                                                                                                                                              |
| --------------------- | ------------------------------------------ | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **T1 — Delegated**    | I cannot evaluate the output               | Generator                 | Constrain blast radius. Treat as disposable. Do not publish as a research artifact or cite as a contribution. Require explanation-before-implementation on every change. |
| **T2 — Supervised**   | I can evaluate but not efficiently produce | Drafter                   | Every diff read line by line. **I** finalize or approve the acceptance criteria and oracle basis. No merge without applicable checks.                                    |
| **T3 — Instrumented** | I could write it myself                    | Accelerator and adversary | Use for review, refactoring, alternative implementations, docs. Not for first drafts of core domain logic.                                                               |

**Consequence ceiling for T1.** Delegation without independent evaluation is
acceptable only for low-consequence, isolated, replaceable work. Security
boundaries, credentials or privacy-sensitive processing, safety- or regulated
functionality, research-critical numerical logic, and production-critical
infrastructure may not remain under ordinary T1 review. Either obtain competent
independent human review for the affected change or sever the dependency / keep
the work out of the consequential path.

_Related work, and a numbering collision:_ Farrag's AI-Augmented Methodology
Taxonomy also defines three numbered tiers, but along a different axis: degree
of AI autonomy (passive suggestion, active generation, autonomous agency)
rather than degree of my evaluative competence.[^17] The two schemes run in
opposite directions at the same numbers — his Tier 3 is maximum AI autonomy,
mine is maximum human competence. Within this document set, `T1`, `Tier 1`, and
`Delegated` are interchangeable names for the same tier (likewise for the other
two); the collision warning applies only when discussing Farrag's taxonomy
alongside this one, and there, use the names rather than the numbers.

### 3.1 Tiers are per-subsystem, not per-repository

A T1 web app can contain a T3 data model. A T3 library's CI configuration
begins T1 by competence — and is promoted to T2 the moment it can block a merge
(subsection 3.2), which is the ordinary case. That gap is not an error: it is
the reason competence and assigned tier are two different things, and it is why
the promotion rule exists at all. **Record the tier next to the module, not on
the front page** — a single repository-level tier is almost always a fiction.

### 3.2 Migration rules (and why they are needed)

Without explicit triggers, tier labels decay into stale decoration. Minimum
rules:

- **Promotion (T1 → T2):** required as soon as a T1 module is imported by a
  T2/T3 module, produces output consumed by a T2/T3 module, or **can block a
  merge to** a T2/T3 path. The dependency propagates the obligation, not the
  other way around. **Promotion does not assert that I can now evaluate the
  path.** It states an obligation, and the obligation has exactly three legal
  discharges: **acquire enough capacity to read the diff**, **obtain a
  competent independent human reviewer who can evaluate the change**, or
  **sever the dependency** — make the check advisory, remove it from required
  status, or move the blocking logic into a path I can read. Leaving an
  unevaluated path in a consequential blocking role is not a discharge. This is
  also why the assigned review obligation of a path can exceed my competence at
  it.

- **Demotion (T3 → T2):** if I have not touched a subsystem in ~6 months and
  cannot answer the three questions in section 1 about it without re-reading
  the code, it is T2 until I have re-read it. (Section 1 requires the answers
  to live in artifacts, never in memory; this trigger tests something else —
  whether I have retained the capacity to evaluate a diff at speed.)
- **T1 is legitimate but accrues debt.** A T1 subsystem is a bet that I will
  never need to change it under time pressure. The debt comes due at the first
  urgent bug. Mitigation is not "learn the whole domain first" — it is to
  require explanation-before-implementation so each change buys a small amount
  of evaluation capacity.

### 3.3 Fallback: when the tier is unclear

If I cannot confidently assign a tier, **assign T2.**

T2 is the only assignment that is safe in both directions. Three things vary
across the tiers, and they do not vary together:

|                          | T1        | T2      | T3          |
| ------------------------ | --------- | ------- | ----------- |
| Competence I am claiming | least     | middle  | most        |
| Latitude the model gets  | Generator | Drafter | Accelerator |
| Review the diff receives | lightest  | heavy   | heaviest    |

"Assume the lower tier" is conservative on the first row only. On the other two
it is the least cautious choice available: assigning T1 to an ambiguous
subsystem gives the model the widest role and the diff the thinnest review. T2
claims no competence I may not have, and grants none of T1's latitude.

Independently of the tier, and regardless of which one is assigned: a subsystem
I cannot evaluate is not cited as a contribution. If a subsystem seems to be
simultaneously T1 and T3 for different reasons, it is two subsystems and should
be split.

---

## 4. Practices

### 4.1 I own the specification; the model writes the implementation

Follow the **explore → plan → code** loop: have the model read and explain the
relevant code, then produce a plan naming which files change and what could
break, then implement against that plan. Skip planning for changes describable
in one sentence; use it when the approach is uncertain, changes span files, or
the code is unfamiliar.[^7]

**Addition specific to ownership:** _I finalize and explicitly approve the
acceptance criteria before implementation begins._ The model may ask questions
or propose missing cases during exploration, but it does not decide what counts
as success. Not necessarily the tests — the criteria.

> "Must be exact in the collinear case; must not allocate an N×N array; must
> match the reference value in `tests/fixtures/analytic.json` to 1e-10."

If I cannot understand and defend that paragraph well enough to approve it, I
do not understand the problem well enough to delegate implementation. That is
useful information, not a blocker.

**Fallback:** for genuinely exploratory work where criteria cannot be stated in
advance, the exploration is T1 by definition and its output is **scratch** —
`sandbox/`, never merged directly. Promotion to `src/` requires a rewrite under
stated criteria.

### 4.2 Make the model prove, not assert

Prompts that shift the burden of proof:

- "Do not write code yet. List three ways this could be wrong, and a check that
  would distinguish them."
- "Diff this branch against `main` and argue the change is _unnecessary_."
- "What invariant does this rely on that is not tested?"
- "Reimplement this a second time, independently, and reconcile the two against
  the same fixtures."

The last is a lightweight form of differential testing: independent
implementations can expose disagreements that deserve investigation,
particularly when a direct oracle is unavailable. Agreement is not itself
ground truth.[^8]

### 4.3 The model never establishes ground truth

**Hard rule.** The reference truth used to validate an implementation or a
scientific claim comes from a human-checked derivation, literature, measured
data, or an independent implementation — **never from the same model output
being validated**. AI-generated material may itself be study data when AI
generation is the documented method; that makes it data, not a validation
oracle.

A model that writes both the implementation and the expected value has proven
nothing, and the failure is invisible because the suite is green.

The blind-second-model device in subsection 4.6 is not an exception: what a
second model produces is a _candidate_ assertion. I accept, amend, or reject it
against an independent basis; a second model agreeing with the first does not
create an oracle. The rule is about independence of the evidence and
accountable human judgement, not about how many models saw the problem.

Corollary: a model may write or run code that computes a reported number. The
reported number must remain traceable to the recorded computation or source,
and I must be able to verify and accept that chain before publication.

**Fallback:** where no independent reference exists, the test asserts a
_property_ (symmetry, conservation, monotonicity, dimensional consistency,
invariance under permutation) rather than fabricating a golden value. Property
checks provide a different kind of evidence from reference-value tests; they do
not manufacture an unavailable oracle.[^9] This failure has been named
independently in the literature: Farrag records circular validation —
AI-generated tests mirroring AI-generated code — as the characteristic risk of
test-driven development under active AI generation.[^17]

### 4.4 Protect restricted inputs before model use

Treat sending material to an external model as a data transfer, not merely as
"prompting." Do not send credentials, secrets, identifiable participant data,
unpublished restricted datasets, embargoed manuscripts or results,
collaborators' confidential material, or third-party code/data whose licence or
agreement forbids that processing unless the provider configuration and the
applicable agreement explicitly permit it and any required consent or approval
has been obtained.[^13] [^14]

Where that status is unclear, keep the material out of the external model. A
project policy may be stricter; no productivity benefit overrides a
confidentiality, consent, contractual, or legal constraint.

### 4.5 Enforce mechanically what intention cannot enforce

Prefer mechanically enforced, auditable controls over prose instructions where
a checkable control exists. Hooks, CI, branch protection, and static checks can
still be bypassed or misconfigured; their advantage is that they reduce
reliance on memory and intention. CI/status checks can also leave auditable
evidence of what ran.[^7]

Baseline:

- Strict static typing where it materially improves checkability and the
  language/toolchain supports it.
- If coverage is used, prefer changed-line/diff coverage or an explicit
  test-to-change requirement; a repository-wide coverage floor alone does not
  prove that new behaviour was tested.
- Small diffs. If a change cannot be reviewed in one sitting, split it.
- Never merge a behavioural change without an applicable check having actually
  run; a model may execute the check, but that does not replace the human
  review required by the tier.
- Commit or back up before granting an agent write access.
- A formatter and a markdown linter in CI, over the prose as well as the code,
  where those checks are useful.

### 4.6 Named failure modes and their guards

| Failure mode                                                                                  | Guard                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Agent "fixes" a failing test by weakening the test                                            | Any diff touching both an implementation and its own test is **blocked pending manual review**. Approved only where an interface change genuinely forces the test to change, and never where assertion values weaken                                                                                                                                                                                                                                                                       |
| Circular validation — the model writes both the implementation and the test that certifies it | No expected value the model produced counts as ground truth (subsection 4.3). Where a model drafts tests, the assertions are authored or replaced by me. A second model with no sight of the implementation may generate **candidate** assertions: these are input to my judgement — accepted, amended, or rejected line by line — and are never merged unread. A candidate is not a reference value, and two models agreeing is not evidence; only their disagreement is informative[^17] |
| Silent scope creep — an unrelated refactor rides along in a diff                              | Reject the diff; re-request scoped                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Confident wrong domain semantics (see section 6)                                              | Domain logic is not delegated; the model touches infrastructure only. Where I cannot evaluate the domain logic, that is a T1 subsystem and is declared as one — restricting the model does not raise the tier                                                                                                                                                                                                                                                                              |
| Duplication instead of refactoring (subsection 2.1)                                           | Periodic duplication scan; treat rising added/copy-pasted ratios as a signal for investigation, not a causal health score                                                                                                                                                                                                                                                                                                                                                                  |
| Context rot — quality degrading late in a long session                                        | Clear context and restart rather than pushing through[^7]                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Two context files (`AGENTS.md`, `CLAUDE.md`) drifting apart                                   | One is canonical; tool-specific files import or point to it. For Claude Code, a `CLAUDE.md` shim can import `@AGENTS.md`; never maintain duplicate rule sets by hand[^7]                                                                                                                                                                                                                                                                                                                   |
| Hallucinated API or citation                                                                  | Any external reference the model supplies is unverified until I open it                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Restricted material sent to an external model                                                 | Apply subsection 4.4 before prompting; where permission, provider handling, or consent is unclear, do not send it                                                                                                                                                                                                                                                                                                                                                                          |
| Agent-facing file grows until instructions are lost in it                                     | Prune on a schedule; for each line ask whether removing it would cause a mistake[^7] [^15]                                                                                                                                                                                                                                                                                                                                                                                                 |

---

## 5. Provenance and disclosure

Several major scholarly publishers and editorial bodies currently converge on
three useful principles: **AI is not a human author; substantive AI use
affecting research or scholarly judgement requires transparency; accountable
judgement remains human.** The details differ and change, so the venue's
current policy is checked at submission rather than inferred from this summary.

- **ACM** — named authors must be identifiable humans and remain accountable.
  Under ACM's current 2026 policy, AI used to conduct research — including
  design, data, code, simulations, analysis, testing, validation, and
  research-relevant figures — must be described in detail in Methods; AI used
  only to assist with writing an ACM submission no longer requires disclosure
  under the general ACM policy.[^10] [^11]
- **IEEE** — AI-generated content, explicitly including text, figures, images,
  and code, is disclosed in acknowledgements with the system identified and the
  affected content and level of use described. Ordinary editing/grammar use is
  generally outside that requirement, though disclosure is recommended.[^12]
- **Nature Portfolio** — the 2026 policy uses a risk-based framework. Human
  accountability is non-transferable; evaluative or interpretive AI use
  requires human oversight, verification, and transparency; opaque delegation
  of scholarly judgement and breaches of confidentiality are not
  permitted.[^13]
- **ICMJE** — authors disclose AI use at submission and in the submitted work,
  describe how it was used, and remain responsible for accuracy, originality,
  attribution, and confidentiality. AI used to conduct a study belongs in
  Methods; other uses are disclosed in the appropriate section of the submitted
  work.[^14]

For research software and AI-assisted research, repository-level disclosure is
a record of practice; it **does not substitute** for whatever statement,
placement, or detail the submission venue currently requires.

### 5.1 Implementation: commit trailers

Cheap, durable, machine-greppable, survives in `git log`:

```text
feat(analysis): add block-averaging estimator for correlated frames

Add block_average() with automatic block-size scan; wire it into the
correlation pipeline behind estimator="block".
Why: the naive standard error underestimates uncertainty on correlated
frames; block averaging is the estimator the analysis plan specifies.

Assisted-by: Claude Code, <model id> (full implementation)
Checks-run: tests/test_estimator.py::test_block_average_analytic — PASS
Ground-truth-source: Flyvbjerg & Petersen (1989), Eq. 20
```

**The why-clause rule.** The rationale must **originate with the human**. A
model may draft the subject and what-changed description, and may copy-edit or
compress a rationale I have already supplied, but it may not invent the reason
the change should exist. Section 1 makes "why does this exist" recoverable from
artifacts, and the commit body is one of the few places that answer survives.
The rule's single full statement lives in each project's `AI-POLICY.md` as
`[WHY-1]`, per the one-home rule of subsection 7.2 and the ID convention of
subsection 7.3. The templates keep `Why: TODO (maintainer)` as the safe
default; a maintainer-supplied rationale may then be copy-edited if requested.

> **About bracketed rule IDs.** IDs such as `[GT-1]`, `[WHY-1]`, and `[TEST-1]`
> are identifiers defined in an adopting project's `AI-POLICY.md`. They are not
> section identifiers in this guideline. This guideline explains the rationale
> for those rules; the policy template supplies their normative definitions.

The explanation-before-implementation required on every T1 change (subsection
3.2) is not in tension with this rule, and the distinction is worth stating
because on a T1 path both apply to the same text: that explanation is the
model's account of **what the change does and how — mechanism**, recorded in
the PR or commit body as model-attributed material. The `Why:` clause is
**rationale** — the judgement that the change should exist — and must originate
with the maintainer even where its final wording is copy-edited by a model.

Trailer vocabulary (extend as needed):

| Trailer                | Format and meaning                                                                                                         |
| ---------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `Assisted-by:`         | `<tool>, <model id> (<role / extent>)` — e.g. `(partial implementation)`, `(full implementation)`, `(review)`              |
| `Checks-run:`          | Checks actually executed and their result — e.g. `pytest tests/test_x.py — PASS`; this is not a claim of verifier identity |
| `Ground-truth-source:` | Where an expected/reference value came from (subsection 4.3)                                                               |
| `Tier:`                | Optional, when the change crosses tiers                                                                                    |

**Scope — which trailers appear on which commits.** `Assisted-by:` appears only
on assisted commits and records the model identifier plus role/extent;
"assistance" includes full generation, so `(full implementation)` is the honest
value where the model produced essentially the whole implementation.
`Checks-run:` appears on every behaviour-changing commit under the full profile
and records the checks actually run and their observed result; it does not
infer or reconstruct a result that was not recorded. `Ground-truth-source:`
appears only when a commit adds or changes an expected or reference value.

A model may execute a human-approved check. That is **check execution**, not
independent verification by the model. If the same model generated the
implementation and supplied the oracle it then satisfied, a green result is
circular and `[GT-1]` still fails in an instantiated `AI-POLICY.md`.
Independence comes from the criterion, reference, property, or competent human
judgement — not from who pressed Enter. Human review obligations remain defined
by the tier.

For commit-attributed code assistance, this makes much of an end-of-project
disclosure queryable from `git log` rather than reconstructed from memory.

**Fallback:** trailers will be forgotten sometimes. That is acceptable — an
incomplete honest record beats a reconstructed one. Do **not** backfill
trailers from memory; if provenance is unknown, the disclosure says so.

### 5.2 Research and prose assistance

Subsection 5.1 assumes code produced by an agent inside a repository. Research
work also includes prose editing, literature support, data analysis, figures,
and conceptual or methodological critique, whose natural unit of record is not
always a commit. This document set itself is a simple case: **prose written by
a human and then edited by AI tools**.

That case is disclosed differently, and deliberately so.

|                | Code assistance (subsection 5.1)                  | Prose assistance (this subsection)                                                                                 |
| -------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Unit of record | The commit                                        | The file and the release                                                                                           |
| Mechanism      | `Assisted-by:` trailer                            | `AI-DISCLOSURE.md`                                                                                                 |
| Why            | A commit is the natural boundary of a code change | Editing passes cross commits, files, and tools; per-commit attribution would imply a precision that does not exist |

**The rule:** where the author writes the idea, the argument, or the draft, and
an AI tool edits that input, provenance is recorded at file and release level
in `AI-DISCLOSURE.md`. Commit trailers are not required and should not be
fabricated to look thorough. Inline editing assistance is not individually
reconstructable; the disclosure says so under its known-limitations section
rather than pretending otherwise.

For AI-assisted research beyond code, `AI-DISCLOSURE.md` records the tool,
role, affected artifact or stage, and the human oversight at a level that can
be defended without inventing false precision. The standing rules still apply:
model-supplied citations and empirical claims remain unverified until I open
the source; ground truth is independent; final methodological and interpretive
judgements are mine; and a manuscript submission follows the venue's current
disclosure requirements. How much deeper process documentation conceptual or
theoretical research should require is intentionally left open (section 9).

**Publisher context, and why this is not a loophole.** The Association for
Computing Machinery (ACM) and the International Committee of Medical Journal
Editors (ICMJE) are cited as evidence of where the disclosure line currently
sits, not as the authority this subsection derives from; if either relaxed its
rules tomorrow, nothing here would change.[^10] [^14] ACM's 2026 policy exempts
writing assistance from its general disclosure requirement while still
requiring detailed disclosure of AI used in conducting the research.[^10] ICMJE
requires disclosure of AI use in the submitted work and at submission.[^14] The
editing pattern this subsection describes falls on the non-required side of
ACM's general rule but not necessarily of another venue's. Disclosing it anyway
is a choice, made because a document set arguing for honest disclosure would
undercut its own argument by omitting its own. Where a document was instead
drafted from a specification, that is generation, and the disclosure says so
rather than folding it in with the editing.

**The mixed case — and the canonical statement of the editing/origination
line.** Where an agent both edits files and makes the commits — scoped by path,
per subsection 8.6 — the commit becomes a discrete, attributable action again,
and subsection 5.1 applies to those commits even though the content is prose:
they carry `Assisted-by:`, on the squash commit where a branch is
squash-merged. Prose the author edits by hand remains under this subsection; a
repository may honestly run both regimes at once. The line that matters is who
originates the judgement, not who types. "Make this clearer" is editing. "What
am I missing" can produce useful candidate reasoning, but that output is input
to a human decision: a model may identify an option or objection; it does not
originate the normative judgement that the governing document finally adopts.
Subsection 8.6 enforces this line, by path, for the repository that holds the
governing documents.

For a prose-only repository, file/release-level disclosure can be the whole
provenance mechanism. It does **not** relax subsection 5.1 where a model writes
code, and it does not replace venue-specific disclosure for submitted research.

### 5.3 Licence and copyright provenance of generated code

If generated code reproduces or closely resembles identifiable third-party
code, that creates a provenance and licensing problem distinct from the
security result in subsection 2.1. A generated passage with an identifiable
external origin is treated as third-party material rather than assuming
generation erased its provenance.

Mitigations, in order:

- Enable the tool's code-reference, duplication, or matching filter where one
  exists.
- Treat any sizable generated block with an identifiable external origin as
  third-party code: attribute it under its licence, or replace it.
- Record the position taken in `AI-DISCLOSURE.md`.

---

## 6. Where the model's knowledge stops

The most dangerous output is not the one that errors. It is the one that is
**correctly implemented and domain-wrong** — because it passes review, passes
tests written under the same misconception, and produces numbers.

A useful default is to distinguish work that is mechanically checkable from
judgement that depends on field-specific meaning. Model capability varies by
model, task, and context; the table below is a risk partition, not a claim that
a model universally "knows" one side and not the other. In scientific code, for
example, a statistically inappropriate estimator can be implemented perfectly.

**Operational split:**

| AI may draft / execute, subject to the tier | Human judgement required                                                            |
| ------------------------------------------- | ----------------------------------------------------------------------------------- |
| Parsing, IO, filesystem traversal           | Observable definitions                                                              |
| Test scaffolding and fixtures               | Reference/oracle validity                                                           |
| Refactoring, renaming, type annotations     | Error estimation and uncertainty                                                    |
| Documentation and copy-editing              | Aggregation and model-selection semantics                                           |
| Packaging, tooling, boilerplate             | Domain invariants, final methodological choices, and acceptance of reported results |

The model may propose options on the right; the final decision is human and
must be defensible. This split **cuts across module boundaries** rather than
following them. A single package will usually contain both.

---

## 7. Document set and division of labour

The table lists the full document set and what each file is for. Which of them
a given project instantiates is a function of its adoption profile (subsection
7.1) — the full set is the ceiling, not the requirement. (A repository under
git carries a `README.md` regardless; this guideline claims only its AI
section.)

| File                         | Audience                              | Contents                                                                                                            | Volatility  |
| ---------------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----------- |
| `AGENTS.md` / `CLAUDE.md`    | The model                             | How to run tests; module map; project vocabulary; conventions a linter cannot express; explicit _don't_ list        | High        |
| `AI-POLICY.md`               | Humans — me, collaborators, reviewers | Tier assignments; ground-truth rule; disclosure convention; categorical prohibitions; review requirements           | Low         |
| `AI-DISCLOSURE.md`           | Readers, citers, reviewers            | What was assisted, by what, checked/overseen how — per release or manuscript                                        | Per release |
| `README.md`                  | Anyone landing on the repo            | Project front page; carries the AI section (a screen at most): tiers in use, standing constraint, pointer to policy | Low         |
| `CONTRIBUTING.md` AI section | External contributors                 | Disclosure expectation for PRs; the ground-truth rule as it binds outsiders                                         | Low         |

Separately from the per-project set, the author keeps private working notes —
an evidence log, an error log, open questions. These are personal, not part of
any repository.

**Keep the agent-facing file short.** It is loaded every session and competes
for context with the actual work. Point to detail; do not inline it.[^15]

**Where each document's history lives.** A document that makes a claim someone
could rely on carries its own revision table _inside itself_, so that "when did
this start applying" is answerable from the file alone and survives the file
being copied elsewhere. That covers `AI-POLICY.md`, `AI-DISCLOSURE.md`, and a
guideline like this one. A document that only tells a tool how to work makes no
such claim, and its history is version control: `AGENTS.md` carries no version
and no changelog, and adding one would be noise. Repository-level history —
what was done and when — belongs to the version control system, releases, and
the issue tracker, never to a document.

### 7.1 Which documents a project instantiates

The cost of the set must be proportional to the project, or the set will be
abandoned rather than maintained.

**Each document is instantiated independently, when the question it answers
becomes live for this project.** They answer four different questions — _how
does a tool work here_ (`AGENTS.md`), _what is permitted here_
(`AI-POLICY.md`), _what was assisted in this release_ (`AI-DISCLOSURE.md`),
_what is expected of a contributor_ (the CONTRIBUTING section) — and no one of
them is a prerequisite for another. A repository may hold exactly one of them
and be correctly configured. The profiles below are the two configurations that
arise most often, **not the permitted set**; a project whose shape matches
neither takes the documents its questions require and no others.

Three shapes that fall outside the profiles, recorded because they are common
enough to be mistaken for errors:

- **Disclosure alone.** A manuscript, a Zenodo deposit, or a one-off analysis
  that must account for its AI use, in a repository with no agent instructions
  and no policy to cite. Subsection 8.5 already says this document's value does
  not depend on anyone else's cooperation; it does not depend on any other
  document either.
- **Prose-only repository** (subsection 5.2). Where AI use is editing rather
  than code generation and no coding agent runs, `AGENTS.md` is scaffolding for
  a tool that is not there and the commit-trailer convention has no work to do.
  The set is `AI-DISCLOSURE.md`, optionally a README section. Instantiating
  `AGENTS.md` here is the placeholder failure of subsection 8.2 in another
  form: a file that looks like an instruction and instructs nothing.
- **Policy alone.** A rule that needs to be citable in review, in a repository
  where no agent runs and nothing has been released. Rare, but coherent.

**Minimal profile — the default for a solo-maintained repository that runs a
coding agent.** Three artifacts:

1. the README AI section, variant B (or variant C where it is the honest one);
2. `AGENTS.md`, minimal variant (subsection 8.1), whose commit-format block is
   where the trailer convention is written down under this profile;
3. the lightweight commit-trailer convention of subsection 5.1, adopted
   directly — stated in that block, since a convention an agent is expected to
   follow and can read nowhere is not adopted, it is remembered.

No `AI-POLICY.md`, no `AI-DISCLOSURE.md`, no CONTRIBUTING section. Where no
policy file exists, the README section's pointer to one is deleted and its
standing-constraint sentences _are_ the policy, and the minimal `AGENTS.md`'s
Do-not list is written to stand alone for the same reason. The categorical
rules of this guideline — ground truth (subsection 4.3), test integrity, the
why-clause rule (subsection 5.1) — bind the author's practice regardless of
which files exist; the profile changes what is written down, not what is done.

**Full profile.** All five documents. For research software whose numbers are
published, any repository with collaborators, and any project where a rule
needs to be citable rather than merely followed.

**Triggers** — each names the one document it requires, and fires independently
of the others. A trigger is not a step in a sequence: any of them may be the
first, and none of them presupposes that an earlier one has fired.

| Trigger                                                            | Instantiate                                                         |
| ------------------------------------------------------------------ | ------------------------------------------------------------------- |
| A collaborator arrives, or a rule needs to be citable in review    | `AI-POLICY.md` (full `AGENTS.md` variant becomes available with it) |
| First release, archive, or manuscript that must account for AI use | `AI-DISCLOSURE.md`                                                  |
| First external PR                                                  | `CONTRIBUTING.md` AI section (subsection 8.1 already says this)     |

**Every template is therefore written to arrive alone.** A first release can
require `AI-DISCLOSURE.md` before any collaborator has required `AI-POLICY.md`,
and a first external PR can require the CONTRIBUTING section before either. The
disclosure's `governed-by:` takes an explicit value naming whatever rules are
actually in force — including none written down; the CONTRIBUTING section ships
a self-contained variant B; the README section and the minimal `AGENTS.md`
already stand alone. Instantiating a variant that cites `AI-POLICY.md` into a
repository that holds no policy produces a link to a file the reader cannot
open — the failure subsection 8.3 step 3 already forbids for the README, and it
is the same failure for a rule ID pointing into a policy that does not exist
(subsection 7.3).

The categorical rules of this guideline bind the author's practice regardless
of which documents exist, and that is what makes independent instantiation
safe: the documents record the practice, they do not constitute it.

De-escalation is not a failure: a project that instantiated the full set and
finds the policy file untouched for a year may honestly fall back to the
minimal profile, recording the retirement in the policy's own changelog before
deleting it.

### 7.2 One home per rule

Every normative rule in an adopting project has exactly **one full statement**,
and it lives in that project's `AI-POLICY.md`. The other documents relate to it
in fixed ways:

- **`AGENTS.md`** carries the operational one-liner plus a pointer to the
  policy rule, cited by ID (subsection 7.3) — never a second full statement.
- **This guideline** carries the _reasoning_ — why the rule exists and what
  evidence it rests on — and defers the per-project statement to the policy.
- **README and CONTRIBUTING sections** may carry short audience-specific
  operational summaries, but they point to the rule ID and explicitly defer to
  the policy rather than becoming a second authority.

The motive is maintenance, not tidiness: every restatement is a file the
maintainer must remember to update in sync, and paraphrase drift between
restatements is precisely the failure mode of subsection 4.6's two-context-file
row, generalised. A pointer cannot drift; a paraphrase does little else. Under
the minimal profile, where no policy file exists, the minimal `AGENTS.md` holds
the one-liners as the sole written statement — one home still, just a smaller
house. The same holds for any configuration carrying no policy file: the one
home is wherever the rule is actually written, and there is exactly one such
place per rule in every configuration.

### 7.3 Pointers cite rule IDs, not section numbers

Subsection 7.2 makes every cross-document reference a pointer. A pointer
written as a section number — `§4`, `section 5` — is not one: it encodes a
claim about _where_ a rule sits, which stops being true the moment a subsection
is inserted above it, and nothing fails when it does. That is paraphrase drift
in its quietest form, and it is the two-context-file row of subsection 4.6 one
level down.

Each rule in a project's `AI-POLICY.md` that is referenced from another
document therefore carries a bracketed ID at its single home — `[GT-1]` for
ground truth, `[WHY-1]` for the why-clause rule — and every pointer cites the
ID. The convention:

- An ID is allocated once and **never reused**, including after its rule is
  deleted. A stale pointer then resolves to nothing rather than to whatever
  rule inherited the number.
- Sections may be renumbered, reordered, or split freely. IDs do not move.
- A rule that acquires an external pointer acquires an ID in the same commit.
- **The convention is checkable, and is therefore checked.** Extract every ID
  defined in `AI-POLICY.md` and every ID referenced in `AGENTS.md`,
  `README.md`, and `CONTRIBUTING.md`; fail on any reference with no definition.
  This is subsection 4.5 applied to the document set itself — the one place the
  set previously relied on instruction where tooling was available. The policy
  template carries the check as an enforcement row.

Prose signposting _within_ a single document — "see subsection 8.6" — stays as
section numbers. It addresses a human reading that document, breaks visibly
when wrong, and gains nothing from an ID.

---

## 8. Templates

Section 7 says which documents exist. This section says how they are produced,
instantiated, and kept from drifting.

### 8.1 The template set

Templates are held in one place and copied into repositories — not reinvented
per project. Canonical location: `<meta-repo>/templates/`.

| Template file                         | Instantiates as                | Per                   | Filled at                                |
| ------------------------------------- | ------------------------------ | --------------------- | ---------------------------------------- |
| `agents-template.md`                  | `AGENTS.md`                    | repository            | repo setup; revised as structure changes |
| `ai-policy-template.md`               | `AI-POLICY.md`                 | repository            | repo setup; revised on tier change       |
| `ai-disclosure-template.md`           | `AI-DISCLOSURE.md`             | release or manuscript | release / submission time                |
| `readme-ai-section-template.md`       | a section of `README.md`       | repository            | repo setup                               |
| `contributing-ai-section-template.md` | a section of `CONTRIBUTING.md` | repository            | repo setup, or on the first external PR  |

**Stored filenames differ from instantiated filenames on purpose.** Coding
agents load context by exact filename — `AGENTS.md`, `CLAUDE.md`,
`.cursorrules`, and equivalents. A template stored as `AGENTS.template.md` may
be mistaken by tooling or maintainers for live instruction in the repository
that stores it, where it is scaffolding for somewhere else. Stored names are
therefore lowercase, hyphenated, and chosen so that no reserved filename
appears in them. The instantiated names in target repositories are
unchanged.[^16]

**Licence.** This guideline is CC BY 4.0; the templates are dedicated under CC0
1.0 and carry their own `LICENSE` in `<meta-repo>/templates/`. The split is
deliberate: CC BY would impose exactly the pointer-back that subsection 8.2
disclaims, and a governance file that obliges its adopter to credit a document
the reader does not hold is the failure that subsection warns about.

Three templates ship variants. `readme-ai-section-template.md` ships **three**
— full, minimal, and one written for a project the author does not fully own.
`agents-template.md` and `contributing-ai-section-template.md` ship **two**
each — full and minimal, keyed to the adoption profiles of subsection 7.1, with
the minimal variant the default for a solo-maintained repository. In every
case, choosing the flattering or the heavier variant when the honest or the
proportionate one applies is the specific failure this set exists to prevent.
The minimal variants exist for a second reason as well: an escalation trigger
can deliver a document into a repository that holds no `AI-POLICY.md`, and a
variant that cites one would then point at nothing.

### 8.2 What a template is and is not

- **A template is scaffolding.** It guarantees that a question was _asked_, not
  that it was answered well.
- **A template is not authority.** Authority lives in the project's own
  `AI-POLICY.md`, and nowhere else. Nothing further is required — not this
  guideline, not the template the file came from, not any external policy. A
  template that contradicts the policy it instantiated into is a bug in the
  template.
- **An instantiated document owes this guideline nothing.** It may cite a
  journal policy, a funder requirement, a standard, or nothing at all. Copying
  a template does not create an obligation to carry a reference back to its
  source.
- **Placeholders are not neutral.** An unfilled `<...>` in a committed file is
  worse than an absent file: it looks like a policy and is not one.

### 8.3 Instantiation checklist

1. **Choose the adoption profile first** (subsection 7.1). It decides which
   templates are copied at all, and which variant of the README section and of
   `AGENTS.md` is kept.
2. Place each chosen template in the target repository, by kind:
   - _Whole-file templates_ (`agents-template.md`, `ai-policy-template.md`,
     `ai-disclosure-template.md`): copy in and **rename to the instantiated
     name** per the table in subsection 8.1 (`agents-template.md` →
     `AGENTS.md`). The stored name is never the committed name.
   - _Section templates_ (`readme-ai-section-template.md`,
     `contributing-ai-section-template.md`): paste the body into the existing
     `README.md` or `CONTRIBUTING.md` and delete the copied file. Nothing is
     renamed, because nothing new is committed.
3. Keep one variant, delete the rest: one of the three README variants, one of
   the two `AGENTS.md` variants, one of the two CONTRIBUTING variants. Under
   the minimal profile, delete the README variant's pointer to `AI-POLICY.md`
   as well, take variant B of the CONTRIBUTING section, and give
   `AI-DISCLOSURE.md`'s `governed-by:` its minimal-profile value — a link to a
   file the repository does not carry is worse than no link, and a rule ID
   pointing into a file that does not exist is the same failure.
4. Delete every HTML comment block.
5. Replace every `<...>` placeholder — or **delete the row, section, or
   checkbox entirely.** No placeholder survives the first commit. _Exception:_
   in `AI-DISCLOSURE.md` section 4, an unchecked box is a recorded state rather
   than an unfilled placeholder. It is left unchecked and explained beneath the
   list, never deleted.
6. _`AI-POLICY.md` and `AI-DISCLOSURE.md` only:_ set the file's own `version:`
   to `v0.1.0` and date it. No template in the set carries a `derived-from:`
   field, and none should be added — a pointer to a document the reader does
   not hold is worse than no pointer (see subsection 8.4). The other three
   templates carry no header at all.
7. Verify, where `AI-POLICY.md` was instantiated: does its tier table match the
   paths that actually exist in the repo?

**Gate:** a template is not "adopted" until step 7 passes — or, under the
minimal profile, until step 5 does. A committed file containing `<YOUR NAME>`
is a signal that none of this was done.

### 8.4 Versioning of instantiated documents

**Universal.** Each instantiated document _that makes a claim someone could
rely on_ — `AI-POLICY.md` and `AI-DISCLOSURE.md`, per section 7 — carries its
own `version:` and its own revision table, and versions independently of
everything else: of the template it came from, of any guideline, and of the
other documents in the same repository. `AGENTS.md` and the README and
CONTRIBUTING sections carry neither; their history is version control. A
project's `AI-POLICY.md` moving from v0.1.0 to v0.2.0 says something about that
project and nothing about anything else. This is the whole of the rule for a
project that instantiated a template once.

(For how _this_ document versions, see subsection 10.1. That scheme governs the
guideline itself and is not inherited by anything instantiated from it.)

**Guideline bumps and instantiated documents.** For an author maintaining this
guideline across several projects:

- **On a MINOR guideline bump:** instantiated documents may stay as they are.
  Update opportunistically.
- **On a MAJOR guideline bump:** every instantiated document is stale until
  reviewed. Review is mandatory, since a MAJOR bump means a past decision may
  no longer be justified.

Which repositories adopt the guideline is tracked in a plain list in the
meta-repository's working notes, not in the adopting documents themselves. A
tracking mechanism whose upkeep exceeds the cost of the thing it tracks is
over-engineering, however principled its design.

### 8.5 Fallbacks

Templates fit imperfectly, and the failure mode is filling a section that does
not apply rather than deleting it. The table below covers the situations that
arise most often when instantiating a template into a project; the last two
rows apply only to a maintainer of the template set itself.

| Situation                                                                   | Do this                                                                                                                                                                                                         |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A template section does not apply to this project                           | Delete the section and note the deletion in the file's changelog where it has one (`AI-POLICY.md`, `AI-DISCLOSURE.md`); otherwise the commit message carries the rationale. Do not leave it empty.              |
| A template and the project's own policy disagree                            | The policy wins. It is the authority (subsection 8.2); the template is scaffolding that no longer fits.                                                                                                         |
| Collaborator will not adopt the templates                                   | Instantiate `AI-DISCLOSURE.md` anyway — it is the one document whose value depends on neither anyone else's cooperation nor any other document in the set (subsection 7.1).                                     |
| The project needs one document and none of the others                       | Instantiate that one. Documents are independent by design (subsection 7.1); a repository holding a single file from this set is correctly configured, not half-adopted.                                         |
| _(Template-set maintainers)_ The project needs something no template covers | Write it locally first. Promote it to the template set only after it has survived **two projects** — two independent codebases with different problems, so that a rule is never generalised from a single case. |
| _(Template-set maintainers)_ Two repositories need contradictory rules      | The contradiction belongs in their respective `AI-POLICY.md` files, not in the template. Templates hold what generalises; parameterising one to cover both is how a template starts encoding nothing.           |

### 8.6 Do not let an agent maintain the template set

Templates encode judgement about what to be careful about. An agent asked to
"improve" them will reliably produce more sections, more thorough-looking
coverage, and a longer `AGENTS.md` that costs context every session.[^15]
Length is the failure mode here, not the goal.

Agents may _fill_ a template. Revising the template itself is a human decision,
recorded in a changelog.

**The editing/origination line is defined in subsection 5.2; here it is
enforced rather than restated. Where an agent operates on the repository that
holds the governing documents, scope it by path, not only by instruction.** An
agent may apply maintainer-supplied wording or propose candidate edits, but
normative judgement must originate with the maintainer. Approving a generated
diff is not by itself evidence that the underlying judgement was independently
made; protected paths and review gates keep that distinction visible.

**Enforcement.** An instruction the agent reads is advisory, and an agent that
has read this subsection can still reason its way past it — subsection 4.5
applies here as much as anywhere. Two constraints on the enforcement mechanism
follow, and a CI path check satisfies neither on its own:

- **The mechanism cannot live where the agent can write.** A workflow under
  `.github/` does not constrain an agent that may edit `.github/`.
- **The mechanism cannot check what the rule says.** "May apply
  maintainer-originated edits, may not originate normative judgement" is not
  decidable from a diff: a diff shows which paths changed, never who originated
  the judgement.

What is enforceable is a review gate. The normative paths — this guideline,
`templates/`, `AI-POLICY.md`, `AI-DISCLOSURE.md` — are covered by `CODEOWNERS`
requiring my review, and `CODEOWNERS`, `.github/workflows/`, and branch
protection settings sit outside the agent's write scope. Repository settings
are mine alone under `AI-POLICY.md` `[GIT-4]` and outside agent write scope
under `[SCOPE-3]`, and that reservation is what makes this binding rather than
advisory. The agent may open a pull request touching a normative path; it will
not merge without my review. That is the checkable form of the rule, and it is
weaker than the rule: it guarantees I saw the text, not that I originated it.
The remaining distance is mine to hold — and the policy template's enforcement
table states the checkable proposition rather than the rule, precisely so that
a filled policy does not claim a gate it does not have.

The stronger option is to remove the agent's write access to those paths
altogether and commit that prose by hand. It costs the mixed-case complexity of
subsection 5.2 and buys a rule with no interpretive surface. Either arrangement
is recorded per repository in `AI-POLICY.md` `[SCOPE-1]`–`[SCOPE-3]`.

> **Worked example.** In the repository holding this guideline, an agent runs
> git, opens pull requests, and edits `.gitignore` and repository scripts. It
> does **not** hold write access to `.github/workflows/`, `CODEOWNERS`, or
> repository settings, since those are the paths that constrain it. The
> guideline, the templates, `AI-DISCLOSURE.md`, and the normative sections of
> `AI-POLICY.md` are covered by `CODEOWNERS`; the agent may apply
> maintainer-originated edits or commit them, but it may not originate their
> normative judgements. The set's prose assistance — all of it editing — is
> disclosed in full in that repository's `AI-DISCLOSURE.md`, per subsection
> 5.2, though none of it is submitted to a venue. The path split is recorded in
> that project's `AI-POLICY.md` `[SCOPE-1]`–`[SCOPE-3]` — which is where such a
> list belongs, since it is a fact about one repository rather than a rule that
> generalizes.

---

## 9. Open questions

Recorded so they are not mistaken for settled. An open question is something I
do not know the answer to.

1. Does explanation-before-implementation actually build evaluation capacity in
   a T1 domain, or does it produce the _feeling_ of understanding? (subsection
   2.1 suggests scepticism about felt understanding.)
2. At what point does a T1 subsystem become unmaintainable, and is there an
   early indicator short of a failed urgent fix? Farrag's moderating variables
   — task abstraction level, codebase maturity, and developer experience —
   offer at least a vocabulary for the question, if not an answer.[^17]
3. Is the model/human split in section 6 stable as models improve, or does it
   need re-drawing per model generation? If the latter, this document needs a
   per-model appendix.
4. Does the commit-trailer convention survive contact with a collaborator who
   does not use it? The contributing-file position (subsection 8.1's
   `contributing-ai-section-template.md` — disclosure in the PR description;
   trailers optional for outsiders; the maintainer annotates at merge) is the
   current answer, but it is untested against a real external PR.
5. Do the templates (section 8) change behavior, or only produce documents that
   describe behavior? The honest test is whether a filled `AI-POLICY.md` has
   ever caused a change to be rejected.
6. **Verification layers in research software.** How should the framework
   distinguish check execution, software validation against an independent
   reference, methodological validation, and scientific validation of the
   choices that determine reported results? The current rule set keeps those
   concepts separate but does not yet provide a richer taxonomy.
7. **Process transparency for non-code research.** How much process history is
   useful for AI-assisted literature synthesis, conceptual reasoning, figures,
   and manuscript development before documentation becomes performative or
   falsely precise? Loi (2026) argues for richer process transparency in ethics
   research; whether that model generalises is unsettled.[^21]
8. **Post-merge debt.** Should high-risk AI-assisted code receive a later
   maintenance check after merge, rather than treating merge as the end of
   verification? The large-scale preprint evidence on persistent AI-introduced
   issues makes this worth testing, but does not yet establish an optimal
   review horizon.[^19]
9. **Adversarial gates.** Structured adversarial critique and external
   verification gates are plausible complements to ordinary review. IACDM is a
   recent formalisation of that idea, but its comparative effectiveness remains
   a research hypothesis; this guideline therefore borrows the principle, not
   its eight-phase process.[^20]

### 9.1 Known gaps

Distinct from the questions above: not things I do not know the answer to, but
things this guideline does not yet cover and knows it. Actionable work on them
lives in the repository's issue tracker, per section 7 — a gap is stated here
so the scope of the document is honest; the to-do is not.

- **Model-identifier decay.** `Assisted-by: Claude Code, <model id>` is
  reconstructable only while that string still denotes something. Product and
  model identifiers may be retired, renamed, or remapped over time, and a
  disclosure whose `tools:` field records only a broad product name can become
  ambiguous at exactly the moment the archive it accompanies starts to matter.
  The disclosure template now asks for the API model string, or a date of use
  alongside the marketing name, which mitigates rather than solves it: there is
  no durable public registry of retired model identifiers to point at.
- **Provider-specific data governance.** Subsection 4.4 now supplies the
  baseline rule — restricted material is not sent where permission or provider
  handling is unclear — but this guideline does not yet model provider
  retention, training use, jurisdiction, enterprise agreements, institutional
  policy, or discipline-specific consent requirements.
- **Multi-agent provenance.** Parallel agents, subagents, and agent-to-agent
  delegation can make one `Assisted-by:` line an incomplete account of who did
  what. The current format records the tools/models materially involved but
  does not define a provenance graph.
- **Human skill retention.** The framework manages output verification but does
  not yet measure whether repeated delegation erodes the human capacity needed
  to perform that verification. Evidence is developing; no operational rule is
  adopted yet.
- **Non-code research provenance granularity.** `AI-DISCLOSURE.md` records
  roles and affected artifacts, but the appropriate unit of record for
  literature synthesis, conceptual reasoning, exploratory analysis, and figure
  development remains unsettled (open question 7).

---

## 10. Changelog

### 10.1 Versioning scheme

Semantic-ish versioning applied to prose:

| Bump                        | Trigger                                                                                                            |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **MAJOR** (v1.0.0 → v2.0.0) | A core principle changes or is retracted. Anything that would invalidate past decisions made under this guideline. |
| **MINOR** (v0.1.0 → v0.2.0) | A new practice, tier, rule, or section is added. Existing rules remain valid.                                      |
| **PATCH** (v0.1.0 → v0.1.1) | Wording, examples, new references, corrections that do not change what is required.                                |

Every change is recorded below with a date and a one-line rationale. **Do not
silently edit.** The value of this file is partly as a record of how the
position evolved.

### 10.2 Revisions

| Version | Date       | Change         |
| ------- | ---------- | -------------- |
| v0.1.0  | 2026-08-15 | Initial draft. |

---

## 11. References

**Volatility and recheck-by dates.** A reference is one of two kinds. A _fixed_
source — a paper, a preprint version, a dated report — says the same thing
whenever it is opened, and needs only a citation. A _living_ source — a policy
page, a vendor's documentation, a continuously revised handbook — can change
under its own URL without notice, and a claim resting on one is only as current
as the last time it was read.

Living sources below carry `accessed` and `recheck by` dates, and a source that
has gone away is marked `retired`. The three are different states:

- **accessed `<date>`** — the date the source was last opened and read, and on
  which the sentence citing it was confirmed true of the source _as it then
  stood_. It is a claim about the author's act, not about the source.
- **recheck by `<date>`** — the date after which the citation is no longer
  trusted without reopening the source. It expires the author's confidence, not
  the source. This is why a modification date on the source is not a substitute
  for rechecking: a policy page revised under the same URL may carry a date
  that says something changed without saying what, which is the case the
  mechanism exists for. **A citation past this date is stale, and any claim
  resting on it is provisional until the source has been reopened.** Rechecking
  means opening the page, comparing the claim against the current text, and
  then either advancing the date (unchanged) or amending the text with a
  changelog entry (changed). Advancing the date without reopening the page
  defeats the mechanism entirely.
- **retired** — the source has moved, been withdrawn, or gone dead. This is a
  broken citation rather than a stale one, and is recorded as
  `retired — superseded by <x>` or `retired — no replacement found`, never
  silently dropped.

How far out to set a recheck date is a judgement about how fast the source
moves: a few months for vendor documentation tied to a shipping product, half a
year for a policy page, a year for a continuously revised handbook.

Living sources are rechecked in one annual pass; **the section-wide date is
recheck by 2027-08-13**, and footnotes covered by it say `annual pass` rather
than carrying their own date.

[^1]:
    Joel Becker, Nate Rush, Beth Barnes, and David Rein. 2025. _Measuring the
    Impact of Early-2025 AI on Experienced Open-Source Developer Productivity_.
    METR. Accessed August 13, 2026: [metr-2025-study]. Living source — METR has
    revised this page since publication; the February 2026 update cited in
    subsection 2.1 is [^18]. Recheck: annual pass (see the batching rule
    above).

[^2]:
    William Harding and Matthew Kloster. 2024. _Coding on Copilot: 2023 Data
    Suggests Downward Pressure on Code Quality_. GitClear. Dated report;
    treated as fixed. Retrieved from [gitclear-2024].

[^3]:
    Hammond Pearce, Baleegh Ahmad, Benjamin Tan, Brendan Dolan-Gavitt, and
    Ramesh Karri. 2021. Asleep at the Keyboard? Assessing the Security of
    GitHub Copilot's Code Contributions. arXiv:2108.09293. Later published in
    _2022 IEEE Symposium on Security and Privacy (SP)_, 754–768. Fixed source.
    [pearce-2021].

[^4]:
    Jared Bauer. 2024. Does GitHub Copilot improve code quality? Here's what
    the data says. The GitHub Blog. Dated post; treated as fixed.
    [github-copilot-quality].

[^5]:
    DORA and Google Cloud. 2024. _Impact of Generative AI in Software
    Development_. Dated report; fixed source. Retrieved from [dora-2024-genai].

[^6]:
    DORA and Google Cloud. 2025. _State of AI-assisted Software Development_.
    Dated report; fixed source. Retrieved from [dora-2025-report].

[^7]:
    Anthropic. n.d. _Best Practices for Claude Code_. Accessed August 13, 2026:
    [anthropic-cc-best-practices]. Recheck: annual pass.

[^8]:
    William M. McKeeman. 1998. Differential Testing for Software. _Digital
    Technical Journal_ 10, 1 (1998), 100–107. Fixed source; the journal and its
    publisher (Digital Equipment Corporation) are defunct and no publisher
    archive survives. Convenience copy: [mckeeman-1998].

[^9]:
    Koen Claessen and John Hughes. 2000. QuickCheck: A Lightweight Tool for
    Random Testing of Haskell Programs. In _Proceedings of the Fifth ACM
    SIGPLAN International Conference on Functional Programming (ICFP '00)_.
    ACM, 268–279. [claessen-hughes-2000].

[^10]:
    ACM. 2026. _ACM Policy on Authorship_. Accessed August 13, 2026:
    [acm-authorship-policy]. Recheck: annual pass (see the batching rule
    above).

[^11]:
    ACM. n.d. _Frequently Asked Questions - ACM Policy on Authorship_. Accessed
    August 13, 2026: [acm-authorship-faq]. Recheck: annual pass (see the
    batching rule above).

[^12]:
    IEEE. n.d. _Submission and Peer Review Policies_. Guidelines for Artificial
    Intelligence (AI)-Generated Text. Accessed August 13, 2026:
    [ieee-guidelines-and-policies]. Recheck: annual pass.

[^13]:
    Nature. n.d. _Artificial Intelligence (AI)_. Accessed August 13, 2026:
    [nature-ai-statement]. Recheck: annual pass.

[^14]:
    International Committee of Medical Journal Editors. n.d. _Recommendations
    for the Conduct, Reporting, Editing, and Publication of Scholarly Work in
    Medical Journals_ — Artificial Intelligence (AI)-Assisted Technology.
    Accessed August 13, 2026: [icmje-recommendations]. Recheck: annual pass
    (see the batching rule above).

[^15]:
    Thibaud Gloaguen, Niels Mündler, Mark Niklas Müller, Veselin Raychev, and
    Martin Vechev. 2026. Evaluating AGENTS.md: Are Repository-Level Context
    Files Helpful for Coding Agents? In _ICLR 2026 Workshop on Memory for
    LLM-Based Agentic Systems_. arXiv:2602.11988. v2 (2026-06-23).
    [gloaguen-2026].

[^16]:
    Agentic AI Foundation. n.d. _AGENTS.md — A Simple, Open Format for Guiding
    Coding Agents_. Accessed August 13, 2026: [agents-md-spec]. Recheck: annual
    pass.

[^17]:
    Sabry E. Farrag. 2026. _The Productivity-Reliability Paradox:
    Specification-Driven Governance for AI-Augmented Software Development_.
    arXiv:2605.01160v1. Preprint; used as related synthesis rather than as
    settled empirical evidence. [farrag-2026].

[^18]:
    Joel Becker, Nate Rush, Tom Cunningham, David Rein, and Khalid
    Mahamud. 2026. _We are Changing our Developer Productivity Experiment
    Design_. METR, February 24, 2026. Accessed August 13, 2026:
    [metr-2026-update]. Living source; recheck: annual pass.

[^19]:
    Yue Liu, Ratnadira Widyasari, Yanjie Zhao, Ivana Clairine Irsan, and David
    Lo. 2026. _Debt Behind the AI Boom: A Large-Scale Empirical Study of
    AI-Generated Code in the Wild_. arXiv:2603.28592v1. Preprint; treated as
    provisional evidence. [liu-2026-debt].

[^20]:
    Jasmine Moreira. 2026. _IACDM: Interactive Adversarial Convergence
    Development Methodology — A Structured Framework for AI-Assisted Software
    Development_. arXiv:2604.16399v2. Preprint; the paper explicitly treats
    comparative effectiveness as a future empirical hypothesis. [moreira-2026].

[^21]:
    Michele Loi. 2026. _The Journal of Prompt Engineered (Moral) Philosophy,
    Or, Why AI-Assisted Ethics Research Requires Process Transparency_. Version
    5, June 25, 2026. Preprint / working paper; used only to motivate open
    question 7, not as a general reporting standard. [loi-2026].

[metr-2025-study]:
  https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/
[gitclear-2024]:
  https://www.gitclear.com/coding_on_copilot_data_shows_ais_downward_pressure_on_code_quality
[pearce-2021]: https://arxiv.org/abs/2108.09293
[github-copilot-quality]:
  https://github.blog/news-insights/research/does-github-copilot-improve-code-quality-heres-what-the-data-says/
[dora-2024-genai]: https://dora.dev/ai/gen-ai-report/
[dora-2025-report]: https://dora.dev/research/2025/dora-report/
[anthropic-cc-best-practices]: https://code.claude.com/docs/en/best-practices
[mckeeman-1998]:
  https://www.semanticscholar.org/paper/Differential-Testing-for-Software-McKeeman/fc881e8d0432ea8e4dd5fda4979243cac5e4b9e3
[claessen-hughes-2000]: https://dl.acm.org/doi/abs/10.1145/351240.351266
[gloaguen-2026]: https://doi.org/10.48550/arXiv.2602.11988
[acm-authorship-policy]:
  https://www.acm.org/publications/policies/new-acm-policy-on-authorship
[acm-authorship-faq]:
  https://www.acm.org/publications/policies/frequently-asked-questions
[ieee-guidelines-and-policies]:
  https://journals.ieeeauthorcenter.ieee.org/become-an-ieee-journal-author/publishing-ethics/guidelines-and-policies/submission-and-peer-review-policies/
[nature-ai-statement]:
  https://www.nature.com/nature-portfolio/editorial-policies/ai
[icmje-recommendations]:
  https://www.icmje.org/recommendations/browse/artificial-intelligence/
[agents-md-spec]: https://agents.md/
[farrag-2026]: https://doi.org/10.48550/arXiv.2605.01160
[metr-2026-update]: https://metr.org/blog/2026-02-24-uplift-update/
[liu-2026-debt]: https://arxiv.org/abs/2603.28592
[moreira-2026]: https://arxiv.org/abs/2604.16399
[loi-2026]: https://arxiv.org/abs/2511.08639
