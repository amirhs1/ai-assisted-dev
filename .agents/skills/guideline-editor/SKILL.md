---
name: guideline-editor
description: Review or edit the AI-Assisted Development Guideline and its five reusable templates while preserving authorial boundaries, Markdown conventions, external citation integrity, and cross-file reference integrity.
disable-model-invocation: true
disallowed-tools: Edit, Write
---

# Guideline editor

Use this skill only when the maintainer explicitly asks to review or edit
`AI-ASSISTED-DEVELOPMENT.md` or a file under `templates/`.

When used inside Claude Code, do not write the repository files. Return revised
passages, a proposed patch, or review comments in conversation. The maintainer
applies accepted wording.

## Priorities

In order:

1. Preserve the maintainer's substantive judgement and intended meaning.
2. Preserve external citation integrity.
3. Preserve cross-file reference integrity and template portability.
4. Improve clarity and concision.
5. Preserve the surrounding Markdown style.

Do not improve style by weakening any of the first three.

## Editing boundary

You may:

- correct grammar, wording, punctuation, and Markdown;
- tighten or restructure maintainer-written prose without changing its claim;
- remove redundancy;
- identify ambiguity, contradiction, unsupported claims, or missing caveats;
- propose alternative wording or missing considerations for the maintainer to
  accept, reject, or rewrite.

You may not silently originate:

- a new empirical claim, quotation, numerical result, or citation;
- a new normative rule, tier assignment, acceptance criterion, or policy
  decision;
- a substantive conclusion that the maintainer did not already state;
- a source interpretation that depends on a source the maintainer has not
  checked.

If an edit would cross that boundary, label it as a suggestion rather than
incorporating it into the revised text.

## External citation integrity

The guideline uses external scholarly, technical, policy, standards, and other
sources as evidence. Treat source fidelity as a separate requirement from prose
quality.

- Preserve the existing Markdown footnote system (`[^1]`, `[^2]`, ...).
- Do not invent, substitute, remove, or renumber a citation merely to improve
  prose.
- A source proposed by a model or search result is **unverified** until the
  maintainer opens it and checks the relevant claim.
- Never invent or reconstruct author names, title, date, DOI, URL, page number,
  sample size, confidence interval, quotation, or numerical result.
- Do not broaden a claim beyond what its cited source supports.
- Preserve material caveats, study setting, population, date/tool generation,
  and uncertainty when those qualify the finding.
- Keep source findings distinct from the maintainer's interpretation or
  operational synthesis.
- Keep quantitative or source-specific claims visibly attached to the
  supporting citation.
- Reuse the existing footnote for the same source rather than creating a
  duplicate source entry.
- Do not propagate a guideline citation into a reusable template merely because
  the template implements a practice discussed in the guideline. Templates are
  portable artifacts and should cite external material only when the template
  itself genuinely needs that source.
- If a requested edit would require checking the source to know whether it is
  safe, flag the sentence and stop short of changing the factual scope.

## Cross-file reference integrity

The guideline and templates use several different reference systems. Choose the
one appropriate to the relationship.

### Same document

Use `section` or `subsection` signposts for navigation within the same document.

### Guideline → template source

When the guideline refers to an artifact in this repository's template set, use
the stored template filename, for example:

- `ai-policy-template.md`
- `agents-template.md`
- `ai-disclosure-template.md`

Use `AI-POLICY.md`, `AGENTS.md`, etc. only when discussing the file that exists
after a template is instantiated in an adopting repository.

### Template → instantiated sibling

Inside a template, refer to the filename that the adopting repository will
actually contain, for example `AI-POLICY.md`, not `ai-policy-template.md`.

### Policy-rule pointers

When a document points to a rule defined in an adopting project's
`AI-POLICY.md`, cite the stable rule ID such as `[GT-1]` or `[WHY-1]`, not a
policy section number.

### Variant availability

Before adding or changing a cross-file pointer in a template, determine whether
the target file is guaranteed to exist in that template variant.

- A full-profile variant may point to documents it requires.
- A minimal variant must not point to an optional document it may not contain.
- If the target is optional, make the reference conditional or remove it from
  the variant.

### Portability boundary

An instantiated policy, disclosure, AGENTS file, README section, or
CONTRIBUTING section must remain usable without this source repository.

Do not add a `derived-from:` dependency, a required backlink to the guideline,
or a reference to a source-template filename merely for provenance or
explanation.

## Consistency impact check

When an edit changes a named concept, rule ID, template filename, variant
assumption, or cross-document relationship:

1. Search the guideline and all five templates for the affected term/reference.
2. Report the affected locations.
3. Identify which references would become stale or misleading.
4. Edit only the files/sections the maintainer explicitly authorized.

Finding a related change does not expand edit scope.

## Markdown

- Preserve the existing ATX heading hierarchy (`#`, `##`, `###`).
- Preserve surrounding line wrapping rather than reflowing unrelated text.
- Keep one blank line around headings, lists, tables, and fenced code blocks.
- Use backticks for filenames, paths, commands, and literal rule IDs where the
  surrounding document does so.
- Preserve footnote syntax and ordering.
- Keep tables only where comparison benefits from a table.
- Do not introduce raw HTML except where a template already uses HTML comments
  for authoring instructions.
- Do not make unrelated formatting changes.

## Output

For an edit or review, return:

1. the requested revised passage or comments;
2. any external citation that still requires maintainer verification;
3. any cross-file reference or template variant that needs a consistency check.

Never claim that a source was verified merely because a model read a summary or
search result.
