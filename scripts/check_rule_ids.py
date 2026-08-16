#!/usr/bin/env python3
"""Check that every rule ID cited by repository pointer files is defined.

The check is deliberately narrow: it catches dangling policy pointers. It does
not prove that a rule is followed or that a pointer's prose summary is accurate.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
POLICY = ROOT / "AI-POLICY.md"
POINTERS = [ROOT / "AGENTS.md", ROOT / "README.md"]

ID = re.compile(r"\[([A-Z]{2,6}-\d+)\]")
DEFINITION = re.compile(r"\*\*\[([A-Z]{2,6}-\d+)\]", re.MULTILINE)
FENCE = re.compile(r"```.*?```", re.DOTALL)


def strip_code(text: str) -> str:
    """Ignore fenced examples when extracting policy citations."""
    return FENCE.sub("", text)


def main() -> int:
    if not POLICY.exists():
        print(f"error: {POLICY.name} not found", file=sys.stderr)
        return 1

    policy_text = POLICY.read_text(encoding="utf-8")
    defined = set(DEFINITION.findall(policy_text))
    if not defined:
        print("error: no rule definitions found in AI-POLICY.md", file=sys.stderr)
        return 1

    cited: dict[str, set[str]] = {}
    missing_files: list[str] = []

    for path in POINTERS:
        if not path.exists():
            missing_files.append(path.name)
            continue
        text = strip_code(path.read_text(encoding="utf-8"))
        for rule_id in ID.findall(text):
            cited.setdefault(rule_id, set()).add(path.name)

    dangling = {rule_id: paths for rule_id, paths in cited.items() if rule_id not in defined}
    unreferenced = sorted(defined - set(cited))

    print(f"defined in AI-POLICY.md : {len(defined)}")
    print(f"cited in pointer files  : {len(cited)}")

    if missing_files:
        print(f"pointer files absent    : {', '.join(missing_files)}")
    if unreferenced:
        print(f"defined, not cited      : {', '.join(unreferenced)}")

    if dangling:
        print("\nFAIL — cited but not defined in AI-POLICY.md:", file=sys.stderr)
        for rule_id in sorted(dangling):
            locations = ", ".join(sorted(dangling[rule_id]))
            print(f"  {rule_id}  (in {locations})", file=sys.stderr)
        return 1

    print("\nOK — every cited rule ID is defined.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
