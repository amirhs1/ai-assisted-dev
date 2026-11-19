---
name: write-test
description: Write or change a test against approved acceptance criteria, in this project's test framework. Use when a change adds or changes a test; not for only running the suite.
---

<!--
Copy to .agents/skills/write-test/SKILL.md; .claude/skills is a symlink to
.agents/skills. The rules under "Write a test" hold in any language; put the
framework's own rules in the last section. Fill every <...> or delete the
line, and delete this comment.
-->

# Write a test

1. Start from the approved acceptance criteria or test-case list.
2. Name the test after the behaviour it protects: the claim that is false if
   it fails.
3. Test one behaviour.
4. Take each expected value from a source independent of the code under test.
5. Show that each new test can fail, for a bug before the fix, and say so in
   the pull request.
6. Never weaken an expectation or paste observed output to make a test pass;
   report the failure.
7. Leave other files' tests as they are; when rewriting a file, carry forward
   every test that still states a valid contract.
8. Run the changed test first, then the full suite.

## <Your framework's rules>

<Where tests live and how they are named; the commands that run one test and
the full suite, as AGENTS.md, "Commands", gives them; fixtures and test data;
an example test and one not to write; anything else the framework needs.>
