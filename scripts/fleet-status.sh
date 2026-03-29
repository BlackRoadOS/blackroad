#!/bin/bash
# BlackRoad Fleet Status — SSH ping all nodes
set -uo pipefail

PINK='\033[38;5;205m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
AMBER='\033[38;5;214m'
RESET='\033[0m'

declare -A nodes
nodes=(
  [aria]="blackroad@192.168.4.98"
  [alice]="pi@192.168.4.49"
  [octavia]="pi@192.168.4.101"
  [cecilia]="blackroad@192.168.4.96"
  [lucidia]="blackroad@192.168.4.38"
  [gematria]="root@64.227.124.52"
  [anastasia]="root@137.184.54.130"
)

declare -A roles
roles=(
  [aria]="Compute, Hailo-8"
  [alice]="Gateway, Pi-hole, PostgreSQL, Qdrant, Redis, nginx"
  [octavia]="Gitea, Workers, NATS, Docker, Hailo-8"
  [cecilia]="Ollama (16 models), MinIO, PostgreSQL, InfluxDB"
  [lucidia]="334 web apps, nginx, PowerDNS, Ollama"
  [gematria]="Caddy TLS edge (151 domains), Ollama, PowerDNS"
  [anastasia]="Compute, llama.cpp"
)

echo -e "${PINK}BlackRoad Fleet Status${RESET} — $(date)"
echo ""
printf "  %-12s %-8s %-10s %-8s %s\n" "NODE" "STATUS" "UPTIME" "LOAD" "ROLE"
printf "  %-12s %-8s %-10s %-8s %s\n" "----" "------" "------" "----" "----"

online=0
total=${#nodes[@]}

for name in aria alice octavia cecilia lucidia gematria anastasia; do
  target="${nodes[$name]}"
  role="${roles[$name]}"
  
  result=$(ssh -o ConnectTimeout=3 -o BatchMode=yes "$target" 'uptime 2>/dev/null' 2>&1)
  
  if [ $? -eq 0 ]; then
    uptime=$(echo "$result" | grep -oE 'up [^,]+' | head -1 | sed 's/up //')
    load=$(echo "$result" | grep -oE 'load average[s]*: [0-9.]+' | head -1 | sed 's/load average[s]*: //')
    status="${GREEN}UP${RESET}"
    ((online++))
  elif echo "$result" | grep -q "Permission denied"; then
    uptime="—"
    load="—"
    status="${AMBER}AUTH${RESET}"
  else
    uptime="—"
    load="—"
    status="${RED}DOWN${RESET}"
  fi
  
  printf "  %-12s %-18b %-10s %-8s %s\n" "$name" "$status" "$uptime" "$load" "$role"
done

echo ""
echo -e "Fleet: ${GREEN}${online}/${total} online${RESET}"

# JSON output for programmatic use
if [ "${1:-}" = "--json" ]; then
  echo ""
  echo '{"timestamp":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'","online":'$online',"total":'$total'}'
fi
