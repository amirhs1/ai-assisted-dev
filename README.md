# AI-Assisted Development Templates

This repository holds six Markdown templates and one Git commit-message
template for projects that use AI in software development or research. The
companion _AI-Assisted Development Guideline_ will be published separately on
the author's Jekyll website and its public link will be added here when
available.

## Template files

| File                                                                         | Use in an adopting project                                                         |
| ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [`agents-template.md`](agents-template.md)                                   | Adapt as `AGENTS.md` for coding agents.                                            |
| [`ai-policy-template.md`](ai-policy-template.md)                             | Adapt as `AI-POLICY.md` for contributors.                                          |
| [`ai-disclosure-template.md`](ai-disclosure-template.md)                     | Adapt as a disclosure for a specific research output.                              |
| [`readme-ai-section-template.md`](readme-ai-section-template.md)             | Add an AI section to the project's `README.md`.                                    |
| [`contributing-ai-section-template.md`](contributing-ai-section-template.md) | Add a section to `CONTRIBUTING.md`; its second block fits an existing PR template. |
| [`pull-request-template.md`](pull-request-template.md)                       | Use as a complete `.github/pull_request_template.md` when needed.                  |
| [`gitmessage-template.txt`](gitmessage-template.txt)                         | Copy to `.gitmessage` and adapt the commit convention.                             |

The two PR options serve different starting points: add the short AI block to
an existing PR template, or copy the complete PR template. Use one AI prompt in
the resulting PR form.

[`.gitmessage`](.gitmessage) is this repository's own commit-message example.
To use a copied `.gitmessage` for editor-based commits, run
`git config commit.template .gitmessage` in that project. Git does not apply it
to `git commit -m`; check the final message for completed provenance trailers.

## AI disclosure

The author sets the substantive guidance and is responsible for the published
wording. AI tools have assisted with editing and drafting revisions to these
files.

## Licence

The contents of this repository are licensed under
[Creative Commons Attribution 4.0 International](LICENSE) (CC BY 4.0). When
redistributing an adapted template, credit its source, link to the licence, and
indicate that you changed it. An adopting project's README or attribution
notice can carry this information without adding source notes to every
instruction file. The separately published article carries its own CC BY 4.0
notice on the website.

## Status

These are adaptable templates. Replace or remove every placeholder and check
each statement against the adopting project's actual practice before use.
