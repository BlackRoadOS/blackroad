# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

`blackroad` is the local orchestration hub for BlackRoad OS. It contains:

1. **`br` CLI** — dispatcher at `./br` that delegates to `~/bin/br-*` and `~/bin/blackroad-*` commands (163 total)
2. **Org-wide repo enhancement pipeline** — batch tooling to inventory, audit, and apply AGENTS.md baselines across 4 GitHub orgs (~1000+ repos)
3. **Road web gateway** — `road-web-gateway.js`, a Node HTTP reverse proxy that routes `*.localhost` and path-prefix requests to local services (RoadTrip, RoadCode, etc.)
4. **Service manager** — `start-road-websites.sh` manages 9 local services (start/stop/restart/status) with PID files and log rotation

## Common Commands

```bash
# Service management (RoadTrip, RoadCode platform, gateway)
bash start-road-websites.sh start     # Start all 9 services
bash start-road-websites.sh stop      # Stop all
bash start-road-websites.sh status    # Show what's running
bash start-road-websites.sh restart   # Restart all

# Daily report (KPI + service status)
bash scripts/daily-report.sh

# Gateway (runs on :8088, routes to local services)
node road-web-gateway.js

# Org repo pipeline
bash enhance-org-repos.sh inventory   # Pull manifest from 4 orgs via gh API
bash enhance-org-repos.sh plan        # Generate enhancement plan from manifest
bash enhance-org-repos.sh batch 20    # Split manifest into batches of 20

# Batch operations
bash check-org-batch.sh batch-01               # Audit one batch (README/AGENTS/LICENSE/workflows)
bash apply-batch-agents.sh batch-01-checklist.tsv --apply  # Push AGENTS.md to repos (dry-run without --apply)
bash run-all-org-batches.sh                     # Run full rollout across all batches

# Lint shell scripts
shellcheck *.sh
bash -n <script>.sh   # Syntax check only
```

## Architecture

### Batch Enhancement Pipeline

`enhance-org-repos.sh` → `ORG_REPO_MANIFEST.tsv` → batch TSVs → `check-org-batch.sh` → `apply-batch-agents.sh`

- **Manifest** (`ORG_REPO_MANIFEST.tsv`): TSV with org, repo, visibility, default_branch, updated_at
- **Batch checklists** (`batch-NN-checklist.tsv`): TSV with batch, org, repo, + boolean columns for readme, agents, license, workflows
- **Retry files** (`batch-NN-retry.tsv`): Failed repos from a batch run, same format
- **Template**: `AGENTS_BASELINE.md` is the content pushed to each repo's AGENTS.md
- Orgs covered: Blackbox-Enterprises, BlackRoad-AI, BlackRoad-OS, BlackRoad-Labs
- Uses `gh api` exclusively for GitHub operations (no cloning)

### Service Manager (`start-road-websites.sh`)

Pipe-delimited service records: `name|port|dir|command|start_delay|lockfile|install_cmd`

Key services:
- roundtrip (:8094) — RoadTrip chat hub
- roadcode-registry (:3101), roadcode-search (:3102), roadcode-audit (:3103) — RoadCode platform
- roadcode-explorer (:8786), roadcode-prism (:8787) — RoadCode web apps
- road-web-gateway (:8088) — reverse proxy for all of the above

### BR CLI (`./br`)

Thin dispatcher. Resolves `br <cmd>` to `~/bin/br-<cmd>` or `~/bin/blackroad-<cmd>`. Aliases: `sa`→status, `sched`→schedule, `gen`→generate, `mem`→memory. See `BR_COMMAND_INDEX.md` for the full 163-command inventory.

## Key Files

- `ORG_REPO_MANIFEST.tsv` — canonical repo inventory (regenerate with `enhance-org-repos.sh inventory`)
- `AGENTS_BASELINE.md` — template pushed to all repos
- `logs/` — PID files and stdout logs for managed services
- `CODEX_SCRIPT_ARCHIVE_INDEX.md` / `CODEX_SCRIPT_FILENAMES.tsv` — index of all BlackRoad scripts

## Conventions

- All shell scripts use `set -euo pipefail` with UTF-8 locale exports
- `need_bin()` pattern for dependency checks at script start
- Batch TSVs are tab-separated with a header row; boolean columns use 0/1
- Services write `logs/<name>.pid` and `logs/<name>.log`
- Environment override: `BR_ENHANCE_OUT_DIR` changes the working directory for batch scripts (default: `/Users/alexa/blackroad`)
