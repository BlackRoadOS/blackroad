#!/usr/bin/env bash

set -euo pipefail

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
unset LC_ALL

BASE_DIR="${BR_ENHANCE_OUT_DIR:-/Users/alexa/blackroad}"
MANIFEST_PATH="${BASE_DIR}/ORG_REPO_MANIFEST.tsv"
BATCHER="${BASE_DIR}/enhance-org-repos.sh"

usage() {
  cat <<EOF
check-org-batch.sh - inspect one repo batch and write enhancement checklist

Usage:
  check-org-batch.sh <batch-id>

Example:
  check-org-batch.sh batch-01
EOF
}

need_bin() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

check_repo() {
  local org="$1"
  local repo="$2"
  local default_branch="$3"
  local prefix="/repos/${org}/${repo}/contents"

  local names
  names="$(gh api "${prefix}?ref=${default_branch}" --jq '.[].name' 2>/dev/null || true)"

  local has_readme=0
  local has_agents=0
  local has_license=0
  local has_workflows=0

  echo "$names" | rg -qi '^README(\.md)?$' && has_readme=1 || true
  echo "$names" | rg -qi '^AGENTS\.md$' && has_agents=1 || true
  echo "$names" | rg -qi '^LICENSE(\.md)?$' && has_license=1 || true

  gh api "${prefix}/.github?ref=${default_branch}" --jq '.[].name' 2>/dev/null | rg -qi '^workflows$' && has_workflows=1 || true

  printf '%s\t%s\t%s\t%s\t%s\n' "$has_readme" "$has_agents" "$has_license" "$has_workflows" "$names" >/dev/null
  printf '%s\t%s\t%s\t%s\n' "$has_readme" "$has_agents" "$has_license" "$has_workflows"
}

main() {
  need_bin gh
  need_bin rg

  local batch_id="${1:-}"
  [[ -n "$batch_id" ]] || {
    usage >&2
    exit 1
  }

  [[ -f "$MANIFEST_PATH" ]] || {
    echo "Manifest missing: $MANIFEST_PATH" >&2
    exit 1
  }

  local out_path="${BASE_DIR}/${batch_id}-checklist.tsv"
  {
    printf 'batch\torg\trepo\tvisibility\tdefault_branch\tupdated_at\treadme\tagents\tlicense\tworkflows\n'
    "$BATCHER" batch 20 | awk -F '\t' -v batch_id="$batch_id" '$1 == batch_id { print }' | \
      while IFS=$'\t' read -r batch org repo visibility default_branch updated_at; do
        readme=0
        agents=0
        license=0
        workflows=0
        read -r readme agents license workflows < <(check_repo "$org" "$repo" "$default_branch")
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
          "$batch" "$org" "$repo" "$visibility" "$default_branch" "$updated_at" \
          "$readme" "$agents" "$license" "$workflows"
      done
  } > "$out_path"

  echo "Wrote ${out_path}"
}

main "$@"
