#!/usr/bin/env bash
#
#  coverage_report.sh
#  DTBKit
#
#  Reads the newest .xcresult, writes an LLM-friendly Markdown coverage report.
#  Optional: COVERAGE_PREFIXES="Sources/Basic:Sources/Core" to limit scope.
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${COVERAGE_REPORT_OUT:-$REPO_ROOT/coverage-report.md}"
PREFIXES="${COVERAGE_PREFIXES:-}"

find_latest_xcresult() {
  local dirs=("$HOME/Library/Developer/Xcode/DerivedData" "$REPO_ROOT/Example/build")
  local d found best best_ts
  best=""
  best_ts=0
  for d in "${dirs[@]}"; do
    [ -d "$d" ] || continue
    while IFS= read -r found; do
      [ -n "$found" ] || continue
      local ts
      ts=$(stat -f "%m" "$found" 2>/dev/null || echo 0)
      if [ "$ts" -gt "$best_ts" ]; then
        best_ts="$ts"
        best="$found"
      fi
    done < <(find "$d" -name "*.xcresult" -type d 2>/dev/null)
  done
  [ -n "$best" ] && echo "$best"
}

RESULT="${1:-${COVERAGE_XCRESULT:-}}"
if [ -z "$RESULT" ]; then
  RESULT="$(find_latest_xcresult || true)"
fi

if [ -z "$RESULT" ] || [ ! -e "$RESULT" ]; then
  echo "[coverage] no .xcresult found, skip"
  exit 0
fi

TMP_JSON="$(mktemp)"
if ! xcrun xccov view --report --json "$RESULT" > "$TMP_JSON" 2>/dev/null; then
  echo "[coverage] xccov failed; enable coverage with -enableCodeCoverage YES"
  rm -f "$TMP_JSON"
  exit 0
fi

python3 - "$TMP_JSON" "$OUT" "$RESULT" "$REPO_ROOT" "$PREFIXES" <<'PY'
import json
import os
import sys
import time
from collections import defaultdict

json_path, out_path, result_path, repo_root, prefixes_raw = sys.argv[1:6]

prefixes = [p for p in prefixes_raw.split(":") if p]
repo_prefix = repo_root + "/"
source_prefix = os.path.join(repo_root, "Sources") + "/"

with open(json_path) as f:
    data = json.load(f)

files = []
seen = set()
for target in data.get("targets", []):
    for f in target.get("files", []):
        path = f.get("path") or f.get("name") or ""
        if not path.startswith(source_prefix):
            continue
        if path in seen:
            continue
        rel = path[len(repo_prefix):]
        if prefixes and not any(rel.startswith(p) for p in prefixes):
            continue
        seen.add(path)
        executable = f.get("executableLines") or 0
        covered = f.get("coveredLines") or 0
        if executable == 0:
            continue
        functions = []
        for fn in f.get("functions", []):
            cov = fn.get("coverage")
            if cov is None:
                cov = 0.0 if (fn.get("executionCount") or 0) == 0 else 1.0
            if cov < 1.0:
                functions.append({
                    "name": fn.get("name") or "?",
                    "line": fn.get("lineNumber") or 0,
                    "coverage": cov,
                })
        parts = rel.split("/")
        module = parts[1] if len(parts) > 1 else "Sources"
        files.append({
            "path": rel,
            "module": module,
            "executable": executable,
            "covered": covered,
            "uncovered": executable - covered,
            "coverage": (covered / executable) if executable else 1.0,
            "functions": functions,
        })

modules = defaultdict(lambda: {"executable": 0, "covered": 0, "files": 0})
for f in files:
    m = modules[f["module"]]
    m["executable"] += f["executable"]
    m["covered"] += f["covered"]
    m["files"] += 1

total_executable = sum(m["executable"] for m in modules.values())
total_covered = sum(m["covered"] for m in modules.values())
overall = (total_covered / total_executable) if total_executable else 0.0

files.sort(key=lambda f: (-f["uncovered"], f["path"]))
uncovered_files = [f for f in files if f["uncovered"] > 0]

lines = []
lines.append("# Code Coverage")
lines.append("")
lines.append(f"- Result: `{result_path}`")
lines.append(f"- Generated: {time.strftime('%Y-%m-%d %H:%M:%S')}")
lines.append(f"- Scope: {', '.join(prefixes) if prefixes else 'all Sources'}")
lines.append(f"- Overall: **{overall * 100:.1f}%** ({total_covered}/{total_executable} lines)")
lines.append(f"- Files: {len(files)} total, {len(uncovered_files)} with uncovered lines")
lines.append("")

lines.append("## Modules")
lines.append("")
lines.append("| Module | Coverage | Lines | Files |")
lines.append("|---|---|---|---|")
for name, m in sorted(modules.items(), key=lambda x: (x[1]["covered"] / x[1]["executable"]) if x[1]["executable"] else 1.0):
    cov = (m["covered"] / m["executable"]) if m["executable"] else 0.0
    lines.append(f"| {name} | {cov * 100:.1f}% | {m['covered']}/{m['executable']} | {m['files']} |")
lines.append("")

lines.append("## Files")
lines.append("")
lines.append("| File | Coverage | Uncovered |")
lines.append("|---|---|---|")
for f in uncovered_files[:25]:
    lines.append(f"| `{f['path']}` | {f['coverage'] * 100:.1f}% | {f['uncovered']} |")
lines.append("")

uncovered_functions = []
for f in files:
    for fn in f["functions"]:
        uncovered_functions.append((f["path"], fn))

uncovered_functions.sort(key=lambda x: (x[1]["coverage"], x[0], x[1]["line"]))

lines.append("## Uncovered or partial functions")
lines.append("")
if not uncovered_functions:
    lines.append("All functions fully covered.")
else:
    for path, fn in uncovered_functions[:60]:
        lines.append(f"- `{path}:{fn['line']}` **{fn['name']}** — {fn['coverage'] * 100:.0f}%")
lines.append("")

with open(out_path, "w") as f:
    f.write("\n".join(lines))

print(f"[coverage] overall {overall * 100:.1f}% ({total_covered}/{total_executable})")
print(f"[coverage] files with uncovered lines: {len(uncovered_files)}")
print(f"[coverage] uncovered/partial functions: {len(uncovered_functions)}")
for name, m in sorted(modules.items(), key=lambda x: (x[1]["covered"] / x[1]["executable"]) if x[1]["executable"] else 1.0):
    cov = (m["covered"] / m["executable"]) if m["executable"] else 0.0
    print(f"[coverage]   {name:12s} {cov * 100:6.1f}%  ({m['covered']}/{m['executable']})")
print(f"[coverage] report: {out_path}")
PY

rm -f "$TMP_JSON"
