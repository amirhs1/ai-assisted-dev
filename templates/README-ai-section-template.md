<!--
Paste into README.md, near the bottom. Keep it to one screen. Fill every <...>
or delete the line, and delete this comment before committing.

- Keep the paths and tiers in the "Where you may write" table in AGENTS.md
  in step with the table below. Record actual checks, not planned ones.
- Research projects carry these tier assignments and actual checks into
  AI-DISCLOSURE.md as they stood at each release.
- For a small team where each part has one owner, write "we" instead of "I".
-->

## AI assistance

I use AI tools in this project. <Most of it was built with substantial AI help
in a domain where I am not (yet) an independent evaluator.> Each part has a
tier, set by whether I can evaluate AI output there. The table records the
checks or human review applied to each part:

- **Instrumented** — I could write it myself. AI is used for review,
  refactoring, and alternative implementations, not first drafts of core logic.
- **Supervised** — AI drafts; I read every line and set the acceptance criteria
  and test values.
- **Delegated** — AI generates; I can't fully evaluate it. It is covered by
  tests, kept isolated and low-risk, and not presented as my work.

| Part                           | Tier         | Checks or human review                       |
| ------------------------------ | ------------ | -------------------------------------------- |
| `<src/core/>`                  | Instrumented | <named tests, reference, or reviewer>        |
| `<src/io/>`, `tests/`, `docs/` | Supervised   | <named checks and line-by-line human review> |
| `<scripts/>`                   | Delegated    | <named tests and boundary or output checks>  |

Nothing that handles security, credentials, private data, or published results,
or that can block a merge, is Delegated. Where a tier is unclear, I treat the
part as Supervised. Tiers last reviewed: <YYYY-MM-DD>.

<Rules for contributors: [`AI-POLICY.md`](AI-POLICY.md).> <Instructions for AI
agents: [`AGENTS.md`](AGENTS.md).>
