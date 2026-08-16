# AGENTS.md — `ai-assisted-development`

This repository publishes a prose guideline and five reusable templates. The
core prose is the product: coding agents do not write it. `AI-POLICY.md` is the
authority for permissions and rule IDs.

## Commands

| Purpose | Command |
| --- | --- |
| Rule-ID check | `python3 scripts/check_rule_ids.py` |
| Link check | `lychee --config lychee.toml .` |
| Full local check | `python3 scripts/check_rule_ids.py && lychee --config lychee.toml .` |

Run the applicable checks before asking to commit and report the actual result.

## Scope

- Writable repository mechanics: `scripts/`, `.gitignore`, `.gitmessage`,
  `.github/ISSUE_TEMPLATE/` ([SCOPE-1]).
- Core prose is read-only: `AI-ASSISTED-DEVELOPMENT.md`, `templates/`
  ([SCOPE-2]).
- Repository governance/supporting prose and skills are read-only to the coding
  agent ([SCOPE-3]).
- Workflows, Claude permission settings, licence/citation metadata, rulesets,
  and repository settings are maintainer-only ([SCOPE-4]).

The templates are source templates for other repositories. Never fill their
placeholders merely to make this repository look complete.

## Git workflow

1. Inspect the relevant files and diff.
2. Run the applicable checks.
3. **Before staging:** show the intended path set/diff and ask for approval
   ([GIT-2]).
4. **Before committing:** show the staged diff and proposed message and ask for
   approval ([GIT-3]).
5. **Before pushing:** state the destination and commits to be pushed and ask
   for approval ([GIT-4]).
6. Direct push to `main` is normal after approval. Do not open a PR unless the
   maintainer explicitly asks for one.

## Do not

- Edit the guideline/templates or protected governance files.
- Invent or supply external citations, source claims, or attributed numbers
  ([CITE-1], [NUM-1]).
- Break template portability or cross-file reference rules ([REF-1]).
- Invent the rationale for a change ([WHY-1]).
- Weaken a check to make it pass ([TEST-1]).
- Add/change a dependency or third-party Action without approval ([DEP-1]).
- Force-push or change repository settings/secrets.

When reviewing the guideline/templates, use the `guideline-editor` skill
([EDIT-1]) and return suggestions in conversation rather than writing files.

## Commit format

Use `.gitmessage`. Preferred shape:

```text
<type>(<scope>): <subject>

<what changed>
Why: TODO (maintainer)

Assisted-by: <tool>, <model name and version> (<role>)
Verified-by: <check actually run>
```

Trailers are for AI-assisted repository mechanics. Prose editing is disclosed
in `AI-DISCLOSURE.md`, not per commit ([PROV-3]).
