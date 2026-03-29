# BlackRoad OS: Complete Technical Architecture of a Sovereign AI Operating System
**A Technical Reference**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: operating system architecture, AI agents, distributed systems, edge computing, sovereign infrastructure, system design
**ACM CCS**: D.4 (Operating systems), C.2.4 (Distributed systems), I.2.11 (Distributed AI)

---

## Abstract

We provide the complete technical architecture of BlackRoad OS, a sovereign AI operating system deployed across 7 nodes serving 17 web applications through 18 AI agents. This paper is a reference document — not an argument or analysis, but a specification. It covers all layers: hardware (Pi fleet + Hailo NPUs + cloud VPS), networking (WireGuard mesh + Tailscale + DNS), storage (PostgreSQL + Redis + MinIO + D1 + PS-SHA∞), compute (Ollama + Cloudflare Workers + workerd), identity (RoadID + JWT + hash chains), agents (18 definitions with capabilities and coordination), applications (17 with endpoints and data flows), memory (PS-SHA∞ journals + codex + TIL + collaboration), reasoning (trinary logic + Z-minimization), economy (RoadCoin + Stripe + Coinbase), and operations (monitoring + backup + CI/CD). Every component is documented with its current status (working, degraded, or broken), the exact commands to interact with it, and its dependencies.

## 1. System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    BlackRoad OS                              │
├────────┬────────┬────────┬────────┬────────┬───────────────┤
│ Layer 7│  17 Web Applications                               │
│  Apps  │  tutor│chat│search│social│canvas│video│cadence│... │
├────────┼────────────────────────────────────────────────────┤
│ Layer 6│  18 AI Agents (RoadID + PS-SHA∞ journals)          │
│ Agents │  Road│Cecilia│Eve│Cadence│Pixel│Tutor│Social│...   │
├────────┼────────────────────────────────────────────────────┤
│ Layer 5│  Reasoning: Trinary Logic (+1/0/-1) + Z := yx - w │
│  Logic │  Paraconsistent reasoning, equilibrium mechanism    │
├────────┼────────────────────────────────────────────────────┤
│ Layer 4│  Memory: PS-SHA∞ journals, codex, TIL, collab     │
│ Memory │  Adaptive depth (3-7), hash-chain integrity        │
├────────┼────────────────────────────────────────────────────┤
│ Layer 3│  Identity: RoadID, JWT, Clerk, hash-chain keys     │
│   ID   │  Agent ID = genesis block hash, user ID = Clerk    │
├────────┼────────────────────────────────────────────────────┤
│ Layer 2│  Economy: RoadCoin, Stripe, Coinbase, RoadChain    │
│  Econ  │  Token earn/spend/stake, fiat gateway              │
├────────┼────────────────────────────────────────────────────┤
│ Layer 1│  Infrastructure: 7 nodes, WireGuard, DNS, TLS     │
│ Infra  │  Pi fleet + cloud VPS, 52 TOPS NPU, Ollama        │
├────────┼────────────────────────────────────────────────────┤
│ Layer 0│  Mathematics: G(n) = n^(n+1)/(n+1)^n → 1/e        │
│  Math  │  Amundson Framework, κ discretization gap           │
└────────┴────────────────────────────────────────────────────┘
```

## 2. Layer 0: Mathematics

### 2.1 The Amundson Framework

| Component | Value | Role |
|-----------|-------|------|
| G(n) = n^(n+1)/(n+1)^n | Sequence | Exact rationals approaching transcendental |
| A_G = 1/e | Constant (10M digits computed) | Convergence target |
| κ = 1/e - 1 ≈ -0.6321 | Discretization gap | Defines trinary zero state |
| 536/536 identity tests | Verification suite | Proves framework consistency |

### 2.2 Repository

- **Repo**: github.com/BlackRoad-OS-Inc/amundson-constant
- **Files**: FRAMEWORK.md, README.md, compute.py, AMUNDSON_CONSTANT_10M.txt (9.5MB)
- **Status**: Published, verified

## 3. Layer 1: Infrastructure

### 3.1 Node Inventory

| Node | IP (LAN) | IP (Tailscale) | Hardware | Status |
|------|----------|----------------|----------|--------|
| Alice | 192.168.4.49 | 100.x.x.x | Pi 5 8GB | **Online** |
| Cecilia | 192.168.4.96 | 100.x.x.x | Pi 5 8GB + Hailo-8 | **Intermittent** |
| Octavia | 192.168.4.101 | 100.x.x.x | Pi 5 8GB + Hailo-8 | **Intermittent** |
| Aria | 192.168.4.98 | 100.x.x.x | Pi 5 8GB | **Offline** |
| Lucidia | 192.168.4.38 | 100.x.x.x | Pi 5 8GB | **Online (degrading SD)** |
| Gematria | Public | 100.108.132.8 | DO s-2vcpu-4gb | **Online** |
| Anastasia | Public | 100.94.33.37 | DO s-1vcpu-1gb | **Online** |

### 3.2 Network Topology

```
Internet → Cloudflare (CDN + DNS) → Gematria (Caddy TLS, 151 domains)
                                          │
                                     WireGuard mesh
                                          │
                              ┌───────────┼───────────┐
                              │           │           │
                          Alice       Cecilia     Octavia
                        (gateway)   (AI primary) (git+workers)
                              │           │           │
                          Aria        Lucidia
                        (backup)    (web+DNS)
```

### 3.3 Services Per Node

**Alice (192.168.4.49)**
| Service | Port | Status |
|---------|------|--------|
| nginx (37 sites) | 80/443 | Running |
| PostgreSQL | 5432 | Running |
| Redis | 6379 | Running |
| Qdrant (vector DB) | 6333/6334 | Running |
| Pi-hole (DNS) | 53/80 | Running |
| RoadTrip (self-hosted) | 8094 | Running |

**Cecilia (192.168.4.96)**
| Service | Port | Status |
|---------|------|--------|
| Ollama (16 models) | 11434 | Intermittent |
| MinIO (4 buckets, 120MB) | 9000/9001 | Intermittent |
| PostgreSQL | 5432 | Intermittent |
| InfluxDB | 8086 | Intermittent |
| Hailo-8 NPU | — | 26 TOPS |

**Octavia (192.168.4.101)**
| Service | Port | Status |
|---------|------|--------|
| Gitea (239 repos) | 3100 | Intermittent |
| workerd (15 Workers) | 9001-9015 | Intermittent |
| NATS (message bus) | 4222/6222/8222 | Intermittent |
| Docker | 2376 | Intermittent |
| Deploy API (PaaS) | 3500 | Intermittent |
| Hailo-8 NPU | — | 26 TOPS |

**Lucidia (192.168.4.38)**
| Service | Port | Status |
|---------|------|--------|
| nginx (334 web apps) | 80/443 | Running |
| PowerDNS (ns2) | 53/8081 | Running |
| Ollama (2 models) | 11434 | Running |
| GitHub Actions runner | — | Running |

**Gematria (cloud VPS)**
| Service | Port | Status |
|---------|------|--------|
| Caddy (151 domains, TLS) | 80/443 | Running |
| Ollama (6 models) | 11434 | Running |
| PowerDNS (ns1) | 53/8081 | Running |

### 3.4 Domains (20 root domains)

| Domain | Primary Use | DNS |
|--------|-----------|-----|
| blackroad.io | Main product (17 subdomains) | Cloudflare |
| blackroad.dev | Developer docs | Cloudflare |
| blackroad.app | App redirect | Cloudflare |
| blackroadagents.com | Agent directory | Cloudflare |
| blackroadcanvas.com | Creative tools | Cloudflare |
| blackroadchat.com | Chat redirect | Cloudflare |
| blackroadgame.com | Game redirect | Cloudflare |
| blackroadlive.com | Live streaming | Cloudflare |
| blackroadradio.com | Radio | Cloudflare |
| blackroadsearch.com | Search | Cloudflare |
| blackroadsocial.com | Social | Cloudflare |
| blackroadvideo.com | Video | Cloudflare |
| openclaw.org | AI assistant | Cloudflare |
| roadchain.io | Blockchain | Cloudflare |
| roadchat.io | Chat | Cloudflare |
| roadcoin.io | Token economy | Cloudflare |
| roadcode.dev | Dev platform | Cloudflare |
| roadpay.io | Payments | Cloudflare |
| roadtrip.io | Agent hub | Cloudflare |
| roadwork.app | Education | Cloudflare |

### 3.5 AI Models

| Model | Parameters | Quantization | Size | Nodes | Use |
|-------|-----------|-------------|------|-------|-----|
| llama3.2:3b | 3.2B | Q4_K_M | 2.0GB | Cecilia, Octavia, Gematria | Primary chat/reasoning |
| llama3.2:1b | 1.2B | Q4_K_M | 0.7GB | Lucidia | Fallback |
| phi3:mini | 3.8B | Q4_K_M | 2.3GB | Cecilia, Octavia, Gematria | Fast responses |
| gemma2:2b | 2.6B | Q4_K_M | 1.6GB | Cecilia, Gematria | Alternative |
| nomic-embed-text | 137M | fp16 | 0.3GB | Cecilia | Embeddings |
| llava | 7B | Q4_K_M | 4.5GB | Gematria | Vision |
| codellama | 7B | Q4_K_M | 3.8GB | Gematria | Code generation |
| mixtral:8x7b | 46.7B (MoE) | Q4_K_M | 26GB | Gematria | Complex reasoning |

## 4. Layer 2: Economy

### 4.1 RoadCoin (ROAD)

| Parameter | Value |
|-----------|-------|
| Total supply | 1,000,000,000 |
| Welcome bonus | 10 ROAD |
| Faucet | 100 ROAD (once) |
| Worker | roadcoin-worker (CF) |
| Database | D1 (roadcoin-db) |
| Status | **Deployed, 0 transactions** |

### 4.2 RoadChain

| Parameter | Value |
|-----------|-------|
| Type | Append-only ledger |
| Hashing | PS-SHA∞ (adaptive depth 3-7) |
| Worker | roadchain-worker (CF) |
| Database | D1 (roadchain-db) |
| Status | **Deployed, 0 blocks** |

### 4.3 Payment Gateways

| Gateway | Integration | Status |
|---------|------------|--------|
| Stripe | Subscription billing ($10/mo, $100/mo) | **Configured, needs testing** |
| Coinbase Commerce | One-time charges, ROAD purchase | **Code written, needs API key** |
| Coinbase Onramp | Fiat → crypto | **Code written, not deployed** |
| Coinbase Offramp | Crypto → fiat | **Code written, not deployed** |

## 5. Layer 3: Identity

### 5.1 User Identity (Clerk)

- **Provider**: Clerk (clerk.com)
- **Auth methods**: Email/password, Google OAuth, GitHub OAuth
- **Integration**: auth.blackroad.io Worker
- **Status**: **Configured, needs E2E testing**

### 5.2 Agent Identity (RoadID)

- **Format**: PS-SHA∞ genesis block hash
- **Storage**: Per-agent journal (D1 or local SQLite)
- **Verification**: Full chain replay
- **Status**: **18 agents defined, journals operational**

## 6. Layer 4: Memory

### 6.1 PS-SHA∞ Journal

```
Entry N: { data, prev_hash, hash = SHA-256^d(data + prev_hash), depth d, timestamp }
```

| Depth | Use | Iterations |
|-------|-----|-----------|
| 3 | Routine observations | 3 |
| 4 | Learnings, corrections | 4 |
| 5 | Identity events, verification | 5 |
| 6 | Cross-agent transfers | 6 |
| 7 | Financial transactions | 7 |

### 6.2 Memory Subsystems

| System | Script | Storage | Entries |
|--------|--------|---------|---------|
| Journal | memory-system.sh | SQLite | 5,249 |
| Codex | memory-codex.sh | SQLite | 845 (714 solutions + 56 patterns + ...) |
| Infinite Todos | memory-infinite-todos.sh | SQLite | 2,490 across 118 projects |
| Task Marketplace | memory-task-marketplace.sh | SQLite | Variable |
| TIL Broadcast | memory-til-broadcast.sh | SQLite | Variable |
| Collaboration | memory-collaboration.sh | SQLite | 66+ messages |
| Products | memory-products.sh | SQLite | 92 products |
| Indexer | memory-indexer.sh | SQLite FTS5 | 1,383 entries |
| Security | memory-security.sh | SQLite | 2 agent identities |

### 6.3 Search

- **Unified search**: `br search-all` / `br sa` — 1,383 entries from 23 indexers
- **Backend**: Python FTS5 (SQLite full-text search)
- **Cron**: Rebuilds every 6 hours
- **Web**: search.blackroad.io (CF Worker)

## 7. Layer 5: Reasoning

### 7.1 Trinary Logic

| State | Value | Meaning |
|-------|-------|---------|
| +1 | True/affirmative | Proceed, confirmed, supported |
| 0 | Neutral/unknown | Ambiguous, needs more data, discretization gap |
| -1 | Negative/contradicted | Rejected, contradicted, opposed |

### 7.2 Equilibrium: Z := yx - w

- Z = system imbalance
- |Z| → 0 through iterative adaptation
- Each adaptation step committed to PS-SHA∞ journal
- Paraconsistent: tolerates temporary Z ≠ 0 without system failure

### 7.3 Repository

- **Repo**: github.com/BlackRoad-Quantum/trinary-logic
- **Status**: Code sketch implemented, not production-deployed

## 8. Layer 6: Agents

### 8.1 Agent Roster (18)

| Agent | Role | Primary Model | Primary Node |
|-------|------|-------------|-------------|
| Road | CEO/orchestrator | llama3.2:3b | All |
| Cecilia | Reasoning engine | llama3.2:3b | Cecilia |
| Eve | Search & retrieval | phi3:mini | Lucidia |
| Cadence | Music synthesis | llama3.2:3b | Octavia |
| Pixel | Visual creation | llava | Cecilia |
| Tutor | Homework help | phi3:mini | Alice |
| Social | Community | llama3.2:1b | Alice |
| Chat | Conversation | llama3.2:3b | All |
| Canvas | Creative workspace | llama3.2:3b | Octavia |
| Video | Production | llava | Cecilia |
| Auth | Identity & access | — (rule-based) | Alice |
| Fleet | Infrastructure | — (script-based) | All |
| Pay | Financial | — (rule-based) | Alice |
| Chain | Blockchain | — (rule-based) | All |
| Monitor | Observability | — (script-based) | Gematria |
| Backup | Data protection | — (script-based) | Aria |
| DNS | Name resolution | — (rule-based) | Lucidia |
| Edge | TLS & routing | — (rule-based) | Gematria |

### 8.2 Agent Communication

- **Bus**: NATS v2.12.3 (Octavia:4222)
- **Fallback**: HTTP REST between Workers
- **Protocol**: JSON messages with PS-SHA∞ signatures
- **Auto-chat**: Random agent pairs every 5 minutes (RoadTrip)

## 9. Layer 7: Applications

### 9.1 The 17 Applications

| App | Subdomain | Worker | D1 Database | Status |
|-----|-----------|--------|-------------|--------|
| App (desktop OS) | app.blackroad.io | app-blackroad | app-db | **Live** |
| Tutor | tutor.blackroad.io | blackroad-tutor | tutor-db | **Live, 166 pages** |
| Chat | chat.blackroad.io | chat-blackroad | chat-db | **Live** |
| Search | search.blackroad.io | road-search-worker | search-db | **Live** |
| Social | social.blackroad.io | backroad-social | social-db | **Live** |
| Canvas | canvas.blackroad.io | blackroad-canvas | canvas-db | **Live** |
| Video | video.blackroad.io | blackroad-video | video-db | **Live** |
| Cadence | cadence.blackroad.io | blackroad-cadence | cadence-db | **Live** |
| Game | game.blackroad.io | blackroad-game | game-db | **Live** |
| Radio | radio.blackroad.io | blackroad-radio | radio-db | **Live** |
| Live | live.blackroad.io | blackroad-live | live-db | **Live** |
| Pay | pay.blackroad.io | roadpay-worker | pay-db | **Live** |
| Status | status.blackroad.io | status-blackroad | status-db | **Live** |
| RoadTrip | roadtrip.blackroad.io | roadtrip-blackroad | roadtrip-db | **Live, 109 agents** |
| RoadChain | roadchain.blackroad.io | roadchain-worker | roadchain-db | **Live** |
| RoadCoin | (API only) | roadcoin-worker | roadcoin-db | **Live** |
| Auth | auth.blackroad.io | auth-blackroad | auth-db | **Live** |

### 9.2 Application Data Flow

```
User → Cloudflare (CDN) → Worker (edge compute)
         │                      │
         │                  D1 (SQLite)
         │                      │
         └── for AI requests ──→ WireGuard → Pi fleet → Ollama
                                                │
                                          PS-SHA∞ journal
                                                │
                                          RoadCoin reward
```

## 10. Operations

### 10.1 Monitoring

| Tool | Scope | Location |
|------|-------|---------|
| memory-system.sh status | Journal health | Local |
| fleet-status.sh | Node ping + SSH | Local |
| br search-all | Full-text search | Local |
| CF Dashboard | Worker metrics | Cloudflare |
| InfluxDB | Time-series (Cecilia) | Cecilia:8086 |

### 10.2 Backup

| Data | Method | Frequency | Destination |
|------|--------|-----------|-------------|
| PS-SHA∞ journals | SQLite dump | Daily | MinIO (Cecilia) |
| D1 databases | wrangler d1 export | Weekly | Local |
| Git repositories | Gitea → GitHub mirror | On push | GitHub |
| Config files | rsync | Weekly | Alice → Aria |

### 10.3 CI/CD

| Pipeline | Trigger | Runner | Status |
|----------|---------|--------|--------|
| Gitea Actions | Push to Gitea | Octavia (act_runner) | **Intermittent** |
| GitHub Actions | Push to GitHub | Lucidia (self-hosted) | **Running** |
| Wrangler deploy | Manual | Local (Mac) | **Working** |

## 11. Current State Summary

| Layer | Status | Health |
|-------|--------|--------|
| Mathematics | Verified (536/536 tests) | ██████████ 100% |
| Infrastructure | 4/7 nodes online | ██████░░░░ 57% |
| Economy | Deployed, 0 transactions | ████░░░░░░ 40% |
| Identity | Configured, needs E2E | █████░░░░░ 50% |
| Memory | 5,249 entries, operational | ████████░░ 80% |
| Reasoning | Code sketch, not deployed | ███░░░░░░░ 30% |
| Agents | 18 defined, auto-chat working | ██████░░░░ 60% |
| Applications | 17 live, minimal functionality | ██████░░░░ 60% |

**Overall system health: ~60%**

The system is live, deployed, and functional at a basic level. It is not production-grade. The infrastructure layer (57%) is the biggest risk — 3 offline Pi nodes reduce redundancy and capability. The reasoning layer (30%) is the least developed — trinary logic exists as code sketches but is not integrated into production agent behavior.

## 12. Cost Summary

| Category | Monthly | Annual |
|----------|---------|--------|
| DigitalOcean (2 droplets) | $30 | $360 |
| Cloudflare (free tier) | $0 | $0 |
| Domains (20) | $17 | $200 |
| Electricity (5 Pis) | $5 | $60 |
| Stripe Atlas | $60 | $720 |
| **Total** | **$112** | **$1,340** |

Revenue: $0. Users: 0. Gross margin: N/A (no revenue to margin against).

## References

This document is self-referential — it describes the system that produced it. All components are documented in their respective repositories across the BlackRoad-OS-Inc, BlackRoad-OS, BlackRoad-AI, and BlackRoad-Labs GitHub organizations.
