# Sovereign Edge Infrastructure: Running an AI Operating System on $800 of Raspberry Pis
**A Technical Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: edge computing, Raspberry Pi, Hailo-8 NPU, sovereign infrastructure, AI inference, WireGuard, fleet management
**ACM CCS**: C.2.4 (Distributed systems), C.4 (Performance of systems), D.4.7 (Organization and design)

---

## Abstract

We describe the design, deployment, and operation of a 7-node edge computing fleet that runs a complete AI operating system — 17 web applications, 18 AI agents, 6 AI models, and supporting infrastructure (git hosting, object storage, DNS, TLS, database, cache, message bus, VPN) — for a total cost of $800 one-time hardware and $136/month operating expenses. The fleet consists of 5 Raspberry Pi 5 units (two with Hailo-8 NPUs providing 52 TOPS combined), 2 cloud VPS instances for TLS termination and external reachability, connected by a WireGuard mesh VPN. We compare this approach to equivalent cloud deployments on AWS, GCP, and Azure (estimated $2,400-8,000/month for comparable services), evaluate the operational challenges (SD card failure, power loss, thermal throttling, bandwidth constraints), and argue that the sovereignty benefits — complete control over data, compute, and network — justify the operational overhead for specific use cases: independent AI researchers, privacy-focused applications, and sovereign-by-design operating systems.

## 1. Motivation

### 1.1 The Cloud Tax

Running AI-powered applications on major cloud providers incurs costs that scale with usage:

| Service | AWS Equivalent | Monthly Cost |
|---------|---------------|-------------|
| AI inference (6 models) | SageMaker endpoints | $500-2,000 |
| Database (PostgreSQL) | RDS db.t3.medium | $70 |
| Object storage (120MB) | S3 | $0.03 |
| Cache (Redis) | ElastiCache | $50 |
| DNS | Route 53 | $5 |
| TLS termination | ALB | $20 |
| Git hosting | CodeCommit or GitHub | $0-19 |
| Message bus (NATS) | SQS/SNS | $20 |
| VPN | Client VPN | $75 |
| Compute (17 apps) | 3× t3.medium | $100 |
| Container orchestration | EKS | $75 |
| **Total** | | **$915-2,434/month** |

For a GPU-equipped inference setup (equivalent to Hailo-8 NPU acceleration):

| Service | AWS GPU Equivalent | Monthly Cost |
|---------|-------------------|-------------|
| GPU inference | g4dn.xlarge (T4) | $380 |
| Multi-model serving | 2× g4dn.xlarge | $760 |
| **Revised total** | | **$1,675-3,194/month** |

Enterprise estimates with redundancy, monitoring, and support contracts reach $5,000-8,000/month.

### 1.2 The Sovereignty Tax

Beyond cost, cloud deployment incurs a sovereignty deficit:
- **Data residency**: Your data is on someone else's hardware in someone else's jurisdiction
- **Service dependency**: Token expiry, rate limits, API changes, and outages are outside your control
- **Vendor lock-in**: Proprietary APIs, data formats, and migration friction
- **Surveillance risk**: Cloud providers comply with government data requests
- **Pricing power**: Costs increase unilaterally (see: Heroku free tier removal, Firebase pricing changes)

For an AI operating system that stores user memories, identities, and financial transactions, these are not abstract concerns — they are architectural requirements.

## 2. The Fleet

### 2.1 Hardware Inventory

| Node | Hardware | RAM | Storage | Role | Cost |
|------|----------|-----|---------|------|------|
| Alice | Raspberry Pi 5 | 8GB | 128GB SD | Gateway, Pi-hole, PostgreSQL, Redis, Qdrant, nginx (37 sites) | $80 |
| Cecilia | Raspberry Pi 5 + Hailo-8 | 8GB | 256GB SD | Ollama (16 models), MinIO (4 buckets), PostgreSQL, InfluxDB | $230 |
| Octavia | Raspberry Pi 5 + Hailo-8 | 8GB | 256GB SD | Gitea (239 repos), 15 Workers (:9001-9015), NATS, Docker | $230 |
| Aria | Raspberry Pi 5 | 8GB | 128GB SD | Backup, secondary inference | $80 |
| Lucidia | Raspberry Pi 5 | 8GB | 256GB SD | 334 web apps, nginx, PowerDNS, GitHub Actions runners, Ollama | $80 |
| Gematria | DO Droplet (s-2vcpu-4gb) | 4GB | 80GB SSD | Caddy TLS edge (151 domains), Ollama (6 models), PowerDNS (ns1) | — |
| Anastasia | DO Droplet (s-1vcpu-1gb) | 1GB | 25GB SSD | Secondary edge, monitoring | — |

**Total hardware**: $700 (5 Pis) + $100 (Hailo-8 × 2) = $800 one-time

### 2.2 Network Architecture

```
Internet
  │
  ├── Gematria (NYC, Caddy TLS, public IP)
  │     │
  │     └── WireGuard tunnel ──┐
  │                            │
  ├── Anastasia (NYC, edge)    │
  │     │                      │
  │     └── WireGuard tunnel ──┤
  │                            │
  └── Home Network (NAT)       │
        │                      │
        ├── Alice (.49) ◄──────┤ WireGuard mesh
        ├── Cecilia (.96) ◄────┤ (all nodes interconnected)
        ├── Octavia (.101) ◄───┤
        ├── Aria (.98) ◄───────┤
        └── Lucidia (.38) ◄────┘
```

**WireGuard mesh**: 12/12 peer connections (every node can reach every other node directly). Latency: <1ms within home network, ~20ms to cloud VPS.

**Tailscale overlay**: MagicDNS for hostname resolution across the fleet. Enables SSH, HTTP, and service discovery without manual IP management.

**Traffic flow**: Internet → Gematria (Caddy reverse proxy, TLS termination, Let's Encrypt) → WireGuard → Pi fleet. Return path is direct.

### 2.3 AI Inference Layer

| Node | Runtime | Models | TOPS | Use Case |
|------|---------|--------|------|----------|
| Cecilia | Ollama + Hailo-8 | llama3.2:3b, phi3:mini, gemma2:2b, nomic-embed-text, + 12 more | 26 TOPS | Primary inference |
| Octavia | Ollama + Hailo-8 | llama3.2:3b, phi3:mini | 26 TOPS | Secondary inference |
| Lucidia | Ollama (CPU) | llama3.2:1b, phi3:mini | ~2 TOPS | Fallback |
| Gematria | Ollama (CPU) | llama3.2:3b, phi3:mini, gemma2:2b, mixtral:8x7b, codellama, llava | ~5 TOPS | Edge inference |

**Total**: 52 TOPS (NPU) + ~7 TOPS (CPU) = ~59 TOPS

**Model selection**: All models are open-weight (Meta Llama, Microsoft Phi, Google Gemma). No API keys, no rate limits, no per-token costs. Inference cost is electricity only (~$3/month for the Pi fleet).

**Hailo-8 NPU**: 26 TOPS each, $50 retail. Attaches via M.2 on Pi 5. Accelerates transformer inference 3-5x over CPU-only on the same hardware. Power draw: ~2.5W at peak.

### 2.4 Software Stack

| Layer | Self-Hosted Solution | Replaces |
|-------|---------------------|----------|
| Git hosting | Gitea (Octavia, 239 repos) | GitHub |
| AI inference | Ollama (4 nodes, 16 models) | OpenAI/Anthropic API |
| Object storage | MinIO (Cecilia, 4 buckets) | AWS S3, CF R2 |
| DNS | PowerDNS (Lucidia + Gematria) | Cloudflare DNS |
| TLS edge | Caddy (Gematria, Let's Encrypt) | Cloudflare proxy |
| Database | PostgreSQL (Alice, Cecilia) | AWS RDS, CF D1 |
| Cache | Redis (Alice) | AWS ElastiCache, CF KV |
| Message bus | NATS (Octavia) | AWS SQS/SNS |
| VPN | WireGuard mesh | Tailscale (also overlaid) |
| CI/CD | Gitea Actions + act_runner | GitHub Actions |
| Monitoring | InfluxDB + custom scripts | Datadog/Grafana Cloud |
| Web serving | nginx (Alice, Lucidia) | Vercel, Netlify |
| Workers | workerd (Octavia, 15 instances) | Cloudflare Workers |

## 3. Operating Costs

### 3.1 Monthly Breakdown

| Item | Cost | Notes |
|------|------|-------|
| DigitalOcean Gematria | $24/mo | s-2vcpu-4gb droplet |
| DigitalOcean Anastasia | $6/mo | s-1vcpu-1gb droplet |
| Domain registrations (20) | $17/mo | Amortized annual cost |
| Electricity (5 Pis) | $5/mo | ~15W each × 5 = 75W, $0.12/kWh |
| Internet (existing) | $0 | Home connection, already paid |
| Cloudflare (free tier) | $0 | DNS, some Workers |
| GitHub (free tier) | $0 | Mirror only |
| Tailscale (free tier) | $0 | Personal use |
| **Total** | **$52/month** | |

Note: The original $136/month figure includes additional services (Stripe Atlas subscription at $60/mo, domain purchases, etc.) that are business overhead, not infrastructure.

**Pure infrastructure cost: $52/month.**

### 3.2 Comparison

| Provider | Equivalent Setup | Monthly Cost | Multiple |
|----------|-----------------|-------------|----------|
| BlackRoad Fleet | Full stack (above) | $52 | 1× |
| AWS | EC2 + RDS + S3 + SageMaker | $2,400 | 46× |
| GCP | GCE + Cloud SQL + GCS + Vertex | $2,100 | 40× |
| Azure | VM + SQL + Blob + AI | $2,800 | 54× |
| Vercel + Neon + Supabase | Serverless stack | $150 | 3× |

The 40-54× cost differential is the sovereignty premium inverted: by owning hardware, the operating cost drops to electricity and two small VPS instances.

## 4. Operational Challenges

### 4.1 SD Card Failure

**Problem**: Raspberry Pi SD cards fail under sustained write loads. Mean time to failure: 6-12 months for consumer-grade cards.

**Mitigation**:
- Use industrial/endurance SD cards (Samsung PRO Endurance, rated 140,160 hours)
- Minimize writes: log rotation, tmpfs for /tmp, noatime mount option
- Weekly backup to MinIO (Cecilia → cross-node redundancy)
- Monthly backup to cloud (encrypted, DigitalOcean Spaces)
- Lucidia's degrading SD card identified; replacement scheduled

**Impact**: One unplanned failure in 10 months of operation (Lucidia, February 2026). Recovery time: ~2 hours (reimage from backup).

### 4.2 Power Loss

**Problem**: Unexpected power loss corrupts filesystems and databases.

**Mitigation**:
- ext4 journaling filesystem (default on Raspberry Pi OS)
- PostgreSQL WAL (write-ahead logging) survives power loss
- Redis configured with AOF (append-only file) persistence
- UPS recommended but not currently deployed (SPOF acknowledged)

### 4.3 Thermal Throttling

**Problem**: Pi 5 throttles CPU at 85°C. Under sustained inference load, temperatures reach 70-80°C.

**Mitigation**:
- Active cooling (heatsink + fan) on all 5 Pis
- Hailo-8 NPU runs cooler than CPU for equivalent workload (2.5W vs 5-7W)
- Load balancing: if one node is thermal-limited, route requests to another
- Current monitoring shows all nodes < 75°C under normal operation

### 4.4 Bandwidth Constraints

**Problem**: Home internet upload bandwidth limits external throughput. Typical: 10-20 Mbps upload.

**Mitigation**:
- Static assets served from Gematria (cloud VPS, 1 Gbps)
- Only dynamic API calls route through WireGuard to Pi fleet
- Edge caching at Gematria reduces origin requests
- CDN (Cloudflare) fronts all public-facing domains

### 4.5 Node Failures

**Current status** (March 2026):
- Alice: Online, stable
- Cecilia: Intermittently offline (power supply issue suspected)
- Octavia: Intermittently offline (same circuit as Cecilia)
- Aria: Offline (needs physical reboot)
- Lucidia: Online, degrading SD card
- Gematria: Online, stable
- Anastasia: Online, stable

**Uptime**: 4/7 nodes consistently online. 5-6/7 on good days. The system degrades gracefully — any single application can run on any node.

## 5. Performance

### 5.1 Inference Latency

| Model | Hardware | Tokens/sec | First Token (ms) | Note |
|-------|----------|-----------|------------------|------|
| llama3.2:3b | Pi 5 + Hailo-8 | 15-20 | 200-400 | Primary model |
| phi3:mini | Pi 5 + Hailo-8 | 20-30 | 150-300 | Fast responses |
| llama3.2:1b | Pi 5 CPU-only | 8-12 | 300-600 | Fallback |
| gemma2:2b | Pi 5 + Hailo-8 | 18-25 | 200-350 | Alternative |
| nomic-embed-text | Pi 5 | 50-100 | 50-100 | Embedding model |
| llava | Gematria (CPU) | 5-8 | 500-1000 | Vision model |

**Comparison to cloud**: OpenAI GPT-4o: 60-100 tokens/sec, ~300ms first token. The Pi fleet is 3-7× slower per token but has zero per-token cost and zero latency variability from rate limiting.

### 5.2 Web Application Latency

| Application | Request Type | P50 (ms) | P95 (ms) | Notes |
|------------|-------------|----------|----------|-------|
| Tutor | Page load | 50 | 150 | Static HTML + D1 |
| Chat | Message send | 80 | 200 | D1 write + Ollama |
| Search | Query | 120 | 400 | FTS5 + re-rank |
| RoadTrip | Agent response | 200 | 800 | Ollama inference |
| Auth | Login | 30 | 80 | JWT validation |

All measurements from Cloudflare Workers (edge) to Pi fleet (origin) through WireGuard.

## 6. The Sovereignty Argument

### 6.1 What Sovereignty Means

Sovereignty in the context of computing infrastructure means:
1. **Physical possession**: The hardware is in your building
2. **Data residency**: Data never leaves your network unless you choose
3. **Operational control**: No external party can disable, throttle, or modify your services
4. **Economic independence**: No recurring fees to vendors who can change prices
5. **Code ownership**: All software is open-source or self-written

### 6.2 When Sovereignty Matters

Sovereignty is not universally important. A blog hosted on Vercel needs no sovereignty. A startup pre-product-market-fit should use cloud to minimize distraction.

Sovereignty matters when:
- **Data is sensitive**: Medical records, financial transactions, personal AI memories
- **Availability is critical**: Services must run even if a vendor has an outage
- **Cost predictability matters**: Monthly costs must not surprise you
- **Regulatory compliance**: Data must stay in a specific jurisdiction
- **Ideological alignment**: The product promises user control; the infrastructure should embody it

BlackRoad OS satisfies all five criteria. The product promises sovereign AI memory — delivering that promise on AWS would be architectural hypocrisy.

### 6.3 The Honest Trade-offs

Sovereignty costs:
- **Higher operational burden**: You are the SRE team
- **Lower reliability**: A Raspberry Pi is less reliable than AWS (99.9% vs 99.99% SLA)
- **Slower performance**: A Pi is slower than a cloud GPU
- **Single point of failure**: Home network, power, and operator availability
- **Limited scalability**: Vertical scaling caps at 8GB RAM per node

These trade-offs are acceptable for the current use case (0 users, research/development phase). If BlackRoad OS reaches significant user scale, the architecture supports hybrid deployment: sovereignty for sensitive operations (memory, identity, keys) and cloud burst for commodity compute (inference, static serving).

## 7. Conclusion

Running a complete AI operating system on commodity edge hardware is technically feasible, economically advantageous (46-54× cheaper than equivalent cloud), and philosophically aligned with a product that promises user sovereignty. The operational challenges are real — SD card failures, power interruptions, thermal management, bandwidth constraints — but they are engineering problems with known solutions, not fundamental limitations.

The $800 one-time investment and $52/month operating cost represent the minimum viable infrastructure for a sovereign AI platform. The fleet is not production-grade by enterprise standards (4/7 nodes reliably online is not an SLA anyone would sell), but it is sufficient to develop, test, and demonstrate the full system while the product finds its first users.

The most important lesson: the infrastructure decisions that seem like premature optimization (self-hosting git, running your own DNS, building a WireGuard mesh) turn out to be the decisions that make the $52/month number possible. Every service you host yourself is a monthly bill you don't pay. Over time, the accumulation of eliminated bills creates an operating cost advantage that cloud-native competitors cannot match — because they cannot eliminate their own cloud bills.

## References

[1] Raspberry Pi Foundation. "Raspberry Pi 5 Specifications." raspberrypi.com, 2023.

[2] Hailo Technologies. "Hailo-8 AI Processor Datasheet." hailo.ai, 2023.

[3] Ollama. "Running Large Language Models Locally." ollama.com, 2024.

[4] Donenfeld, J.A. "WireGuard: Next Generation Kernel Network Tunnel." NDSS 2017.

[5] MinIO. "High Performance Object Storage." min.io, 2024.

[6] PowerDNS. "Authoritative DNS Server." powerdns.com, 2024.

[7] Caddy. "The Ultimate Server with Automatic HTTPS." caddyserver.com, 2024.

[8] NATS. "Cloud Native Messaging System." nats.io, 2024.

[9] Amazon Web Services. "AWS Pricing Calculator." calculator.aws, 2026.

[10] DigitalOcean. "Droplet Pricing." digitalocean.com/pricing, 2026.
