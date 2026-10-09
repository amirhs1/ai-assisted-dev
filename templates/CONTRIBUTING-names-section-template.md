<!--
Paste into CONTRIBUTING.md as its "Names" section. The default types are
below; drop a type you do not use, add an optional one (release, deps, style)
if you need it, and rename none. Areas are the project's own: list them.
AGENTS.md and the skills keep no copy of these lists; they cite this section.
Fill every <...> or delete the line, and delete this comment.
-->

## Names

Two axes name every change. _Type_, the kind of change, is one word list, used
unchanged as the branch prefix, the commit type, the pull request title's
type, and the label `type:<word>`. _Area_, the part of the repository, is one
list, used unchanged as the commit scope, the issue title's bracket, and the
label `area:<word>`. Scope and area are one list.

```text
types: feat fix docs test refactor ci chore
areas: <area> <area> <area>
```

| Name                          | Form                                    |
| ----------------------------- | --------------------------------------- |
| Branch                        | `<type>/<short-name>`                   |
| Commit and pull request title | `<type>(<area>): <imperative summary>`  |
| Issue title                   | `[<area>] <imperative summary>`         |
| Epic                          | A parent issue, titled as an issue      |
| Milestone                     | `v<MAJOR>.<MINOR>.<PATCH>`, the release |
| Tag and release title         | `v<MAJOR>.<MINOR>.<PATCH>`              |

Labels combine: one `type:` plus one or more `area:`. There are no
combination labels. Status, priority, and release are not labels.

Issue templates set a default type: `type:fix` for a bug report, `type:feat`
for a feature request<, ...>.

### Where these names are used

- `.gitmessage`
- `.github/pull_request_template.md`
- `.github/ISSUE_TEMPLATE/*`
- `.agents/skills/create-branch/SKILL.md`,
  `.agents/skills/draft-release/SKILL.md`,
  `.agents/skills/open-issue/SKILL.md`,
  `.agents/skills/open-pull-request/SKILL.md`,
  `.agents/skills/write-commit/SKILL.md`
- `AGENTS.md`, "Git"

Each of these cites this section.
