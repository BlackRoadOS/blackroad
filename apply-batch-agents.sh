#!/usr/bin/env bash

set -euo pipefail

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
unset LC_ALL

BASE_DIR="${BR_ENHANCE_OUT_DIR:-/Users/alexa/blackroad}"
TEMPLATE_PATH="${BASE_DIR}/AGENTS_BASELINE.md"

usage() {
  cat <<EOF
apply-batch-agents.sh - add baseline AGENTS.md to repos in a checklist

Usage:
  apply-batch-agents.sh <checklist.tsv> [--apply]

Default mode is dry-run.
EOF
}

need_bin() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

render_content() {
  local org="$1"
  local repo="$2"
  python3 - "$TEMPLATE_PATH" "$org" "$repo" <<'PY'
import sys
from pathlib import Path

template = Path(sys.argv[1]).read_text()
org = sys.argv[2]
repo = sys.argv[3]

header = f"# AGENTS.md for {org}/{repo}\n\n"
print(header + template, end="")
PY
}

put_agents() {
  local org="$1"
  local repo="$2"
  local branch="$3"
  local content_b64
  content_b64="$(render_content "$org" "$repo" | base64 | tr -d '\n')"

  gh api \
    --method PUT \
    "/repos/${org}/${repo}/contents/AGENTS.md" \
    -f message="docs: add AGENTS baseline" \
    -f branch="$branch" \
    -f content="$content_b64" >/dev/null
}

main() {
  need_bin gh
  need_bin python3
  need_bin base64

  local checklist="${1:-}"
  local mode="${2:-}"

  [[ -n "$checklist" ]] || {
    usage >&2
    exit 1
  }

  [[ -f "$checklist" ]] || {
    echo "Checklist not found: $checklist" >&2
    exit 1
  }

  local apply=0
  [[ "$mode" == "--apply" ]] && apply=1

  awk -F '\t' 'NR > 1 && $8 == 0 { print $2 "\t" $3 "\t" $5 }' "$checklist" | \
    while IFS=$'\t' read -r org repo branch; do
      if [[ "$apply" -eq 1 ]]; then
        printf 'apply\t%s/%s\t%s\n' "$org" "$repo" "$branch"
        put_agents "$org" "$repo" "$branch"
      else
        printf 'dry-run\t%s/%s\t%s\n' "$org" "$repo" "$branch"
      fi
    done
}

main "$@"
