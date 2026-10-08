# Contributing

## Names

Two axes name every change. _Type_, the kind of change, is one word list, used
unchanged as the branch prefix, the commit type, the pull request title's
type, and the label `type:<word>`. _Area_, the part of the repository, is one
list, used unchanged as the commit scope, the issue title's bracket, and the
label `area:<word>`. Scope and area are one list.

```text
types: feat fix docs test refactor ci chore style
areas: readme contributing tools agents git github license agents-template policy-template disclosure-template readme-template contributing-template pull-request-template chat-report-template gitmessage-template claude-settings-template skill-templates
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

### Where these names are used

- `.gitmessage`
- `.agents/skills/open-issue/SKILL.md`,
  `.agents/skills/open-pull-request/SKILL.md`,
  `.agents/skills/write-commit/SKILL.md`
- `AGENTS.md`, "Git"

Each of these cites this section.
