#!/usr/bin/env bash

set -euo pipefail

ROOT="/Users/alexa"
BLACKROAD_ROOT="$ROOT/blackroad"
LOG_DIR="$BLACKROAD_ROOT/logs"
mkdir -p "$LOG_DIR"

SERVICES=(
  "roundtrip|8094|$ROOT/roundtrip|node server.js|3|$ROOT/roundtrip/package-lock.json|npm install"
  "roadcode-registry|3101|$ROOT/roadcode-platform|REGISTRY_DB_PATH=./data/roadcode.db REGISTRIES_PATH=./registries REGISTRY_PORT=3101 node services/registry/src/index.js|3|$ROOT/roadcode-platform/pnpm-lock.yaml|corepack pnpm install --frozen-lockfile"
  "roadcode-search|3102|$ROOT/roadcode-platform|SEARCH_DB_PATH=./data/search.db REGISTRY_URL=http://localhost:3101 SEARCH_PORT=3102 node services/search/src/index.js|3|$ROOT/roadcode-platform/pnpm-lock.yaml|corepack pnpm install --frozen-lockfile"
  "roadcode-audit|3103|$ROOT/roadcode-platform|AUDIT_DB_PATH=./data/audit.db AUDIT_CHAIN_PATH=./data/chain.log AUDIT_PORT=3103 node services/audit/src/index.js|3|$ROOT/roadcode-platform/pnpm-lock.yaml|corepack pnpm install --frozen-lockfile"
  "roadcode-explorer|8786|$ROOT/roadcode-platform|REGISTRY_URL=http://localhost:3101 EXPLORER_PORT=8786 node apps/explorer/src/index.js|3|$ROOT/roadcode-platform/pnpm-lock.yaml|corepack pnpm install --frozen-lockfile"
  "roadcode-prism|8787|$ROOT/roadcode-platform|REGISTRY_URL=http://localhost:3101 PRISM_PORT=8787 node apps/prism/src/index.js|3|$ROOT/roadcode-platform/pnpm-lock.yaml|corepack pnpm install --frozen-lockfile"
  "roadcode-worker|8788|$ROOT/roadcode-worker|npm run dev|10|$ROOT/roadcode-worker/package-lock.json|npm install"
  "roadcode-site|8789|$ROOT/roadcode-site|python3 -m http.server 8789|3||"
  "road-web-gateway|8088|$BLACKROAD_ROOT|node road-web-gateway.js|3||"
)

service_field() {
  local record="$1"
  local index="$2"
  IFS="|" read -r -a parts <<<"$record"
  printf '%s' "${parts[$index]-}"
}

service_pidfile() {
  local name="$1"
  printf '%s/%s.pid' "$LOG_DIR" "$name"
}

service_logfile() {
  local name="$1"
  printf '%s/%s.log' "$LOG_DIR" "$name"
}

pid_is_live() {
  local pid="$1"
  kill -0 "$pid" >/dev/null 2>&1
}

port_is_listening() {
  local port="$1"
  lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1
}

cleanup_stale_pid() {
  local name="$1"
  local pidfile
  pidfile="$(service_pidfile "$name")"
  if [ ! -f "$pidfile" ]; then
    return 0
  fi

  local pid
  pid="$(cat "$pidfile" 2>/dev/null || true)"
  if [ -z "$pid" ] || ! pid_is_live "$pid"; then
    rm -f "$pidfile"
  fi
}

ensure_dependencies() {
  local workdir="$1"
  local lockfile="$2"
  local install_cmd="$3"
  local package_json="$workdir/package.json"

  if [ -z "$lockfile" ] || [ -z "$install_cmd" ]; then
    return 0
  fi

  if [ -d "$workdir/node_modules" ]; then
    return 0
  fi

  if [ ! -f "$lockfile" ]; then
    return 0
  fi

  if [ ! -f "$package_json" ]; then
    return 0
  fi

  if ! node -e "
    const fs = require('fs')
    const pkg = JSON.parse(fs.readFileSync(process.argv[1], 'utf8'))
    const count =
      Object.keys(pkg.dependencies || {}).length +
      Object.keys(pkg.devDependencies || {}).length +
      Object.keys(pkg.optionalDependencies || {}).length +
      Object.keys(pkg.peerDependencies || {}).length
    process.exit(count > 0 ? 0 : 1)
  " "$package_json"
  then
    return 0
  fi

  echo "installing dependencies in $workdir"
  (
    cd "$workdir"
    bash -lc "$install_cmd"
  )
}

wait_for_port() {
  local port="$1"
  local wait_seconds="$2"
  local elapsed=0

  while [ "$elapsed" -lt "$wait_seconds" ]; do
    if port_is_listening "$port"; then
      return 0
    fi
    sleep 1
    elapsed=$((elapsed + 1))
  done

  return 1
}

start_service() {
  local name="$1"
  local port="$2"
  local workdir="$3"
  local cmd="$4"
  local wait_seconds="$5"
  local lockfile="$6"
  local install_cmd="$7"
  local logfile pidfile

  logfile="$(service_logfile "$name")"
  pidfile="$(service_pidfile "$name")"
  cleanup_stale_pid "$name"

  if port_is_listening "$port"; then
    echo "$name already listening on :$port"
    return 0
  fi

  ensure_dependencies "$workdir" "$lockfile" "$install_cmd"

  cd "$workdir"
  if command -v setsid >/dev/null 2>&1; then
    nohup setsid bash -lc "$cmd" </dev/null >"$logfile" 2>&1 &
  else
    nohup bash -lc "$cmd" </dev/null >"$logfile" 2>&1 &
  fi

  local pid=$!
  disown "$pid" 2>/dev/null || true
  echo "$pid" >"$pidfile"

  if wait_for_port "$port" "$wait_seconds"; then
    echo "started $name on :$port"
    return 0
  fi

  echo "failed to start $name; check $logfile" >&2
  return 1
}

stop_service() {
  local name="$1"
  local port="$2"
  local pidfile
  pidfile="$(service_pidfile "$name")"
  cleanup_stale_pid "$name"

  local stopped=0
  if [ -f "$pidfile" ]; then
    local pid
    pid="$(cat "$pidfile" 2>/dev/null || true)"
    if [ -n "$pid" ] && pid_is_live "$pid"; then
      kill "$pid" >/dev/null 2>&1 || true
      stopped=1
    fi
    rm -f "$pidfile"
  fi

  local pids=""
  pids="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
  if [ -n "$pids" ]; then
    printf '%s\n' "$pids" | xargs kill >/dev/null 2>&1 || true
    stopped=1
  fi

  sleep 1
  local remaining=""
  remaining="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)"
  if [ -n "$remaining" ]; then
    printf '%s\n' "$remaining" | xargs kill -9 >/dev/null 2>&1 || true
    stopped=1
  fi

  if port_is_listening "$port"; then
    echo "failed to stop $name on :$port" >&2
    return 1
  fi

  if [ "$stopped" -eq 1 ]; then
    echo "stopped $name on :$port"
  else
    echo "$name already stopped on :$port"
  fi
}

run_all() {
  local action="$1"
  local failures=0
  local record

  for record in "${SERVICES[@]}"; do
    local name port workdir cmd wait_seconds lockfile install_cmd
    name="$(service_field "$record" 0)"
    port="$(service_field "$record" 1)"
    workdir="$(service_field "$record" 2)"
    cmd="$(service_field "$record" 3)"
    wait_seconds="$(service_field "$record" 4)"
    lockfile="$(service_field "$record" 5)"
    install_cmd="$(service_field "$record" 6)"

    case "$action" in
      start)
        start_service "$name" "$port" "$workdir" "$cmd" "$wait_seconds" "$lockfile" "$install_cmd" || failures=$((failures + 1))
        ;;
      stop)
        stop_service "$name" "$port" || failures=$((failures + 1))
        ;;
    esac
  done

  return "$failures"
}

status() {
  local record
  for record in "${SERVICES[@]}"; do
    local name port
    name="$(service_field "$record" 0)"
    port="$(service_field "$record" 1)"
    if port_is_listening "$port"; then
      echo "$name up :$port http://127.0.0.1:$port"
    else
      echo "$name down :$port http://127.0.0.1:$port"
    fi
  done
}

case "${1:-start}" in
  start)
    failures=0
    run_all start || failures=$?
    echo ""
    status
    if [ "$failures" -ne 0 ]; then
      exit 1
    fi
    ;;
  stop)
    failures=0
    run_all stop || failures=$?
    echo ""
    status
    if [ "$failures" -ne 0 ]; then
      exit 1
    fi
    ;;
  restart)
    run_all stop >/dev/null 2>&1 || true
    echo "restarting road websites"
    failures=0
    run_all start || failures=$?
    echo ""
    status
    if [ "$failures" -ne 0 ]; then
      exit 1
    fi
    ;;
  status)
    status
    ;;
  *)
    echo "Usage: $0 [start|stop|restart|status]" >&2
    exit 1
    ;;
esac
