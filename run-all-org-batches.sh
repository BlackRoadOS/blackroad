#!/usr/bin/env bash

set -euo pipefail

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
unset LC_ALL

BASE_DIR="${BR_ENHANCE_OUT_DIR:-/Users/alexa/blackroad}"
BATCHER="${BASE_DIR}/enhance-org-repos.sh"
CHECKER="${BASE_DIR}/check-org-batch.sh"
APPLIER="${BASE_DIR}/apply-batch-agents.sh"
LOG_DIR="${BASE_DIR}/logs/org-batch-rollout"

usage() {
  cat <<EOF
run-all-org-batches.sh - run AGENTS baseline rollout across all org batches

Usage:
  run-all-org-batches.sh [start-batch]

Examples:
  run-all-org-batches.sh
  run-all-org-batches.sh batch-03
EOF
}

need_bin() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

batch_ids() {
  "$BATCHER" batch 20 | awk -F '\t' '{ print $1 }' | uniq
}

remaining_agents() {
  local checklist="$1"
  awk -F '\t' 'NR > 1 && $8 == 0 { count++ } END { print count + 0 }' "$checklist"
}

run_batch() {
  local batch_id="$1"
  local checklist="${BASE_DIR}/${batch_id}-checklist.tsv"
  local log_path="${LOG_DIR}/${batch_id}.log"

  {
    echo "== ${batch_id} =="
    date -u +'%Y-%m-%dT%H:%M:%SZ'

    "$CHECKER" "$batch_id"
    local before
    before="$(remaining_agents "$checklist")"
    echo "missing_agents_before=${before}"

    if [[ "$before" -eq 0 ]]; then
      echo "skip=${batch_id}"
      return 0
    fi

    "$APPLIER" "$checklist" --apply || true
    "$CHECKER" "$batch_id"

    local after
    after="$(remaining_agents "$checklist")"
    echo "missing_agents_after=${after}"

    if [[ "$after" -gt 0 ]]; then
      local retry="${BASE_DIR}/${batch_id}-retry.tsv"
      awk -F '\t' 'NR == 1 || $8 == 0' "$checklist" > "$retry"
      "$APPLIER" "$retry" --apply || true
      "$CHECKER" "$batch_id"
      after="$(remaining_agents "$checklist")"
      echo "missing_agents_after_retry=${after}"
    fi
  } | tee "$log_path"
}

main() {
  need_bin awk
  need_bin tee

  mkdir -p "$LOG_DIR"

  local start_batch="${1:-}"
  local started=0

  while IFS= read -r batch_id; do
    if [[ -n "$start_batch" && "$started" -eq 0 ]]; then
      [[ "$batch_id" == "$start_batch" ]] || continue
      started=1
    fi
    run_batch "$batch_id"
  done < <(batch_ids)
}

main "$@"
