#!/usr/bin/env bash

set -euo pipefail

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
unset LC_ALL

OUT_DIR="${BR_ENHANCE_OUT_DIR:-/Users/alexa/blackroad}"
MANIFEST_PATH="${OUT_DIR}/ORG_REPO_MANIFEST.tsv"
PLAN_PATH="${OUT_DIR}/ORG_REPO_ENHANCEMENT_PLAN.md"

ORGS=(
  "Blackbox-Enterprises"
  "BlackRoad-AI"
  "BlackRoad-OS"
  "BlackRoad-Labs"
)

usage() {
  cat <<EOF
enhance-org-repos.sh - inventory and batch-plan org-wide repo enhancements

Usage:
  enhance-org-repos.sh inventory
  enhance-org-repos.sh plan
  enhance-org-repos.sh batch [size]

Outputs:
  ${MANIFEST_PATH}
  ${PLAN_PATH}
EOF
}

need_bin() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

inventory() {
  mkdir -p "$OUT_DIR"
  {
    printf 'org\trepo\tvisibility\tdefault_branch\tupdated_at\n'
    for org in "${ORGS[@]}"; do
      /Users/alexa/bin/gh-repo-inventory "$org" | awk -v org="$org" -F '\t' 'BEGIN { OFS="\t" } { print org, $1, $2, $3, $4 }'
    done
  } > "$MANIFEST_PATH"

  echo "Wrote ${MANIFEST_PATH}"
}

plan() {
  [[ -f "$MANIFEST_PATH" ]] || inventory

  local total public private core
  total="$(tail -n +2 "$MANIFEST_PATH" | wc -l | tr -d ' ')"
  public="$(awk -F '\t' 'NR > 1 && $3 == "public" { count++ } END { print count + 0 }' "$MANIFEST_PATH")"
  private="$(awk -F '\t' 'NR > 1 && $3 == "private" { count++ } END { print count + 0 }' "$MANIFEST_PATH")"
  core="$(awk -F '\t' 'NR > 1 && ($1 == "BlackRoad-OS" || $1 == "BlackRoad-AI") { count++ } END { print count + 0 }' "$MANIFEST_PATH")"

  cat > "$PLAN_PATH" <<EOF
# Org Repo Enhancement Plan

Generated: $(date -u +'%Y-%m-%d %H:%M:%SZ')

## Scope

- Total repos: ${total}
- Public repos: ${public}
- Private repos: ${private}
- Core repos in BlackRoad-OS + BlackRoad-AI: ${core}

## Enhancement Bundle

- Normalize root documentation: \`README.md\`, \`AGENTS.md\`, license posture
- Add local automation notes for BlackRoad CLI and Ollama-based workflows
- Standardize repo metadata and lightweight health/run instructions
- Queue CI/workflow normalization as a second pass, not in the first blast

## Rollout Order

1. Public landing/site repos in \`BlackRoad-AI\` and \`BlackRoad-Labs\`
2. Public product repos in \`BlackRoad-OS\`
3. Private internal automation repos in batches of 20
4. Heavy enterprise mirrors last

## Batch Rule

- Default batch size: 20 repos
- Verify each batch before moving on
- Avoid mirrored or archival repos in the first pass

## Manifest

Source file: \`${MANIFEST_PATH}\`
EOF

  echo "Wrote ${PLAN_PATH}"
}

batch() {
  [[ -f "$MANIFEST_PATH" ]] || inventory
  local size="${1:-20}"
  awk -F '\t' 'NR == 1 || ($1 != "Blackbox-Enterprises" && $2 !~ /^(README|source|source-code|operator|\.github)$/)' "$MANIFEST_PATH" | \
    awk -F '\t' -v size="$size" '
      NR == 1 { next }
      {
        batch = int((count) / size) + 1
        printf "batch-%02d\t%s\t%s\t%s\t%s\t%s\n", batch, $1, $2, $3, $4, $5
        count++
      }
    '
}

main() {
  need_bin gh
  need_bin awk

  case "${1:-}" in
    inventory)
      inventory
      ;;
    plan)
      plan
      ;;
    batch)
      shift || true
      batch "${1:-20}"
      ;;
    help|-h|--help|"")
      usage
      ;;
    *)
      echo "Unknown command: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
