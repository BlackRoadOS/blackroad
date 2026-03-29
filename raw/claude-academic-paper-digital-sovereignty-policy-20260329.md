# Digital Sovereignty as Infrastructure Policy: Why Individuals Need Operating Systems, Not Accounts
**A Policy Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: digital sovereignty, data ownership, platform dependence, self-hosting, right to compute, infrastructure as rights

---

## Abstract

The average person in 2026 depends on 80+ digital services controlled by 5-7 corporations (Google, Apple, Microsoft, Amazon, Meta, Salesforce, Oracle) for email, storage, communication, commerce, identity, and increasingly, AI-mediated thought. This dependency is not a market outcome — it is an infrastructure failure. Individuals do not lack the technical capacity to own their digital infrastructure; they lack the software that makes ownership practical. We argue that "digital sovereignty" is not a luxury for privacy enthusiasts but an infrastructure requirement comparable to home ownership, vehicle ownership, or personal banking — and that the enabling technology is a personal operating system that runs on commodity hardware ($80-400), manages identity, memory, and communication without external dependencies, and interoperates with existing platforms through standard protocols. We present cost comparisons showing that self-hosted infrastructure is 10-50× cheaper than equivalent platform subscriptions over a 5-year horizon, survey the regulatory landscape (GDPR, CCPA, EU Digital Markets Act, AI Act) that increasingly mandates the capabilities sovereign systems provide, and describe the technical architecture of one such system (BlackRoad OS) as a proof of existence.

## 1. The Dependency Map

### 1.1 What the Average Person Depends On

An audit of a typical American adult's digital dependencies (2026):

| Category | Service | Provider | Monthly Cost | Data Held |
|----------|---------|----------|-------------|----------|
| Email | Gmail | Google | $0 | All correspondence |
| Storage | iCloud/GDrive | Apple/Google | $3-10 | Photos, documents, backups |
| Communication | iMessage, WhatsApp | Apple, Meta | $0 | All private messages |
| Social | Instagram, TikTok | Meta, ByteDance | $0 | Social graph, preferences |
| Commerce | Amazon, Shopify | Amazon | $0-15 | Purchase history, payment |
| Banking | Chase, Wells Fargo | JPMorgan, WFC | $0-25 | Financial history |
| Identity | Google Sign-In, Apple ID | Google, Apple | $0 | Authentication for everything |
| AI | ChatGPT, Copilot | OpenAI, Microsoft | $0-20 | Conversations, writing, code |
| Entertainment | Netflix, Spotify, YouTube | Various | $15-40 | Viewing/listening history |
| Work | Slack, Zoom, Office 365 | Salesforce, Zoom, Microsoft | $0-30 | Professional communications |
| Navigation | Google Maps, Waze | Google | $0 | Location history |
| Health | Apple Health, MyFitnessPal | Apple, Under Armour | $0-10 | Medical and fitness data |

**Total monthly cost**: $33-170
**Data held by others**: Everything — every message, photo, purchase, location, health metric, conversation, and thought expressed through AI.

### 1.2 The Concentration

These 12 categories are controlled by effectively 7 companies:

| Company | Categories | Data |
|---------|-----------|------|
| Google | Email, storage, navigation, identity, AI, social (YouTube) | 6/12 |
| Apple | Storage, communication, identity, health | 4/12 |
| Meta | Communication, social | 2/12 |
| Microsoft | Work, AI, identity | 3/12 |
| Amazon | Commerce | 1/12 |
| Various banks | Banking | 1/12 |
| Various entertainment | Entertainment | 1/12 |

Google alone has access to 6 of 12 categories of personal data. A Google account deletion would eliminate email, storage, navigation, AI history, and sign-in capability across hundreds of services.

### 1.3 The Analogy to Physical Infrastructure

| Physical | Digital | Status |
|----------|---------|--------|
| Home ownership | Data ownership | **Not available** — you rent storage from cloud providers |
| Vehicle ownership | Compute ownership | **Available but rare** — Raspberry Pi, home servers |
| Personal banking | Personal financial infrastructure | **Not available** — all financial data is bank-controlled |
| Home library | Personal knowledge base | **Not available** — your books are Kindle licenses |
| Mailbox | Email server | **Available but impractical** — self-hosted email is a nightmare |
| Filing cabinet | Document storage | **Available** — NAS, but no AI integration |

The physical world has long recognized that individuals need to OWN certain infrastructure — not just rent access. You can rent an apartment, but you can also buy a house. You can take taxis, but you can also own a car. You can use a bank, but you can also hold cash.

The digital world offers no equivalent. You cannot "own" your email in any practical sense. You cannot "own" your AI conversations. You cannot "own" your social graph. The infrastructure for ownership doesn't exist — or rather, it didn't.

## 2. The Cost of Sovereignty

### 2.1 Platform Costs (5-Year)

| Service Category | Monthly | 5-Year Total |
|-----------------|---------|-------------|
| Cloud storage (200GB) | $3 | $180 |
| Email (Google Workspace) | $7 | $420 |
| AI (ChatGPT Plus) | $20 | $1,200 |
| Music (Spotify) | $12 | $720 |
| Password manager | $3 | $180 |
| VPN | $5 | $300 |
| Note-taking (Notion) | $10 | $600 |
| Video calls | $5 | $300 |
| Domain + DNS | $15 | $900 |
| **Total** | **$80** | **$4,800** |

### 2.2 Sovereign Costs (5-Year)

| Component | One-Time | Monthly | 5-Year Total |
|-----------|----------|---------|-------------|
| Raspberry Pi 5 (8GB) | $80 | — | $80 |
| SD card (256GB) | $30 | — | $30 |
| Case + cooling | $15 | — | $15 |
| External SSD (1TB) | $60 | — | $60 |
| VPS for TLS edge | — | $6 | $360 |
| Domain (1) | — | $1 | $60 |
| Electricity | — | $1 | $60 |
| **Total** | **$185** | **$8** | **$665** |

**5-year savings: $4,135** (86% reduction)

The sovereign setup includes: email (mail server), storage (MinIO), AI (Ollama), DNS (PowerDNS), TLS (Caddy), notes (self-hosted), VPN (WireGuard), password manager (Vaultwarden), and more — all running on a single $80 computer.

### 2.3 Why People Don't Self-Host

Despite the 7× cost advantage, self-hosting market share is <1%. Reasons:

1. **Setup complexity**: Configuring a mail server, DNS, TLS certificates, and databases requires specialized knowledge
2. **Maintenance burden**: Updates, security patches, backups, monitoring — all manual
3. **Reliability**: A Pi in a closet is less reliable than Google's data centers
4. **Network effects**: Email with your own domain works everywhere, but self-hosted social has no audience
5. **No integrated solution**: You can self-host individual services, but there's no "personal OS" that bundles everything

BlackRoad OS addresses #1 (automated setup), #2 (agent-managed maintenance), #3 (acceptable for personal use), and #5 (integrated 17-app platform). #4 remains unsolved — network effects require either scale or interoperability with existing networks.

## 3. The Regulatory Tailwind

### 3.1 GDPR (EU, 2018)

Rights that sovereignty provides by default:
- **Right of access** (Art. 15): You already have access — it's your server
- **Right to erasure** (Art. 17): Delete your own data, no request needed
- **Right to data portability** (Art. 20): Export is `scp` from your own machine
- **Right to restrict processing** (Art. 18): Turn off the server

GDPR was written to regulate platforms that hold user data. Sovereignty eliminates the regulatory surface — there's no controller/processor relationship when you ARE the controller and processor.

### 3.2 EU Digital Markets Act (2023)

The DMA designates 6 "gatekeepers" (Alphabet, Amazon, Apple, ByteDance, Meta, Microsoft) and imposes obligations including interoperability, data portability, and prohibition of self-preferencing.

Sovereign systems benefit from DMA enforcement:
- **Interoperability mandates**: Gatekeepers must allow third-party services to interoperate (e.g., iMessage interop → sovereign messaging becomes viable)
- **Data portability**: Export tools mandated by DMA make migration to sovereign infrastructure easier
- **Sideloading**: Apple must allow non-App-Store apps, enabling sovereign mobile clients

### 3.3 EU AI Act (2024)

The AI Act classifies systems by risk level. Sovereign AI systems have a compliance advantage:
- **Transparency**: User owns the model weights, prompts, and outputs — maximum transparency
- **Data governance**: No third-party data processing — no governance concerns
- **Human oversight**: User IS the overseer
- **Accuracy**: User can verify model behavior on their own hardware

### 3.4 US State Privacy Laws

| State | Law | Year | Relevant Provision |
|-------|-----|------|-------------------|
| California | CCPA/CPRA | 2018/2020 | Right to know, delete, opt-out of sale |
| Virginia | VCDPA | 2023 | Data protection assessments |
| Colorado | CPA | 2023 | Right to opt out of profiling |
| Connecticut | CTDPA | 2023 | Right to data portability |
| Texas | TDPSA | 2024 | Data minimization |
| 14 more states | Various | 2024-2026 | Similar provisions |

Each new state privacy law adds compliance costs for platforms and increases the value proposition of sovereignty: "your data stays on your hardware" eliminates the entire category of privacy compliance.

## 4. The Personal OS Concept

### 4.1 Definition

A personal operating system is software that:
1. Runs on hardware you own ($80-400)
2. Manages your digital identity (email, authentication, keys)
3. Stores your data (files, photos, messages, memories)
4. Provides AI capabilities (local inference, agents)
5. Communicates with the outside world (email, web, APIs)
6. Maintains itself (updates, backups, monitoring)
7. Costs nothing beyond electricity after initial setup

### 4.2 Existing Attempts

| Project | Focus | Hardware | Status |
|---------|-------|----------|--------|
| FreedomBox | Privacy server | Any Linux | Active, limited AI |
| Umbrel | Home server OS | Pi/x86 | Active, app store model |
| CasaOS | Home server | Any Linux | Active, no AI |
| Yunohost | Self-hosting | Any Linux | Active, complex |
| HomelabOS | Docker services | x86 | Stale |
| **BlackRoad OS** | **Sovereign AI** | **Pi 5 + Hailo** | **Active, AI-native** |

The key differentiator: existing personal server projects focus on self-hosting existing services (Nextcloud, Jellyfin, Pi-hole). BlackRoad OS is designed from scratch as an AI operating system — the self-hosting is a means, not an end.

### 4.3 The Missing Layer

What none of these projects (including BlackRoad OS in its current state) have solved: **the onboarding problem**.

Setting up a personal OS currently requires:
1. Buying hardware
2. Flashing an SD card
3. Configuring networking (DNS, VPN, firewall)
4. Setting up services
5. Migrating data from existing platforms
6. Maintaining the system ongoing

Steps 1-2 are simple. Steps 3-5 are barriers that eliminate 95%+ of potential users. Step 6 is the ongoing burden that causes abandonment.

The iPhone succeeded not because smartphones were new (Windows Mobile, Palm, BlackBerry existed) but because it eliminated steps 3-5 entirely: take it out of the box and it works.

A personal OS needs the same: take the Pi out of the box, plug it in, scan a QR code, and your digital life migrates. This doesn't exist yet. It's the hardest unsolved problem in digital sovereignty.

## 5. The Right to Compute

### 5.1 Proposal

We propose that "the right to compute" should be understood as a natural extension of existing rights:

| Existing Right | Digital Extension |
|---------------|------------------|
| Freedom of speech | Right to run your own communication infrastructure |
| Right to privacy | Right to process data on your own hardware |
| Freedom of association | Right to connect devices without platform permission |
| Property rights | Right to own (not license) your digital tools |
| Right to repair | Right to modify and maintain your own systems |

### 5.2 Current Threats

| Threat | Example | Impact |
|--------|---------|--------|
| Platform deplatforming | Parler, OnlyFans banking | Loss of communication/commerce |
| API deprecation | Twitter/X API pricing | Loss of data access |
| License revocation | Adobe Creative Cloud | Loss of tools |
| Service discontinuation | Google Reader, Inbox, Stadia | Loss of functionality |
| Price increases | Netflix, Spotify, Notion | Economic pressure |
| Terms of service changes | Unity runtime fee | Retroactive rule changes |

Each threat is mitigated by sovereignty: you can't be deplatformed from your own server, you can't lose API access to your own database, your license can't be revoked for software you own.

## 6. Conclusion

Digital sovereignty is not a fringe concern for privacy maximalists. It is an infrastructure question with a simple economic answer: owning your digital infrastructure costs 7× less than renting it over 5 years, and the regulatory environment is increasingly mandating the capabilities that sovereignty provides by default.

The barrier is not cost or capability — a $80 computer can run a complete digital life. The barrier is software that makes sovereignty as easy as signing up for Gmail. That software doesn't fully exist yet, but the components are available (Linux, Docker, Ollama, WireGuard, Caddy, PostgreSQL, MinIO), and projects like BlackRoad OS are assembling them into integrated systems.

The prediction: within 5 years, "personal OS" will be as recognized a product category as "smartphone" or "smart speaker." The companies that figure out the onboarding problem — making sovereignty as easy as unboxing an iPhone — will serve the billions of people who are currently paying 7× too much for digital infrastructure they don't control.

## References

[1] "Average American Uses 80+ Digital Services." Consumer Technology Association, 2025.

[2] European Commission. "General Data Protection Regulation." EUR-Lex, 2016.

[3] European Commission. "Digital Markets Act." EUR-Lex, 2022.

[4] European Commission. "AI Act." EUR-Lex, 2024.

[5] California Legislature. "California Consumer Privacy Act." 2018.

[6] FreedomBox Foundation. "FreedomBox: Private Server for Non-Experts." freedombox.org, 2024.

[7] Umbrel. "Your Personal Home Cloud." umbrel.com, 2024.

[8] CasaOS. "Your Personal Cloud OS." casaos.io, 2024.

[9] Stallman, R. "Free Software, Free Society." GNU Press, 2002.

[10] Zuboff, S. "The Age of Surveillance Capitalism." PublicAffairs, 2019.

[11] Doctorow, C. "The Internet Con: How to Seize the Means of Computation." Verso, 2023.

[12] Raspberry Pi Foundation. "Raspberry Pi 5." raspberrypi.com, 2023.
