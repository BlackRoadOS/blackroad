# AI Colonialism: How Five Companies Conquered the Digital World and How to Decolonize It
**A Critical Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: AI colonialism, digital imperialism, data extraction, compute monopoly, sovereign computing, decolonization, technological self-determination

---

## Abstract

The colonial pattern is: arrive, extract resources, install dependencies, export value, leave the population dependent. In the 18th century, the resources were land, labor, and minerals. In 2026, the resources are data, attention, and compute. Five companies (Google, Microsoft/OpenAI, Meta, Amazon, Apple) control 92% of the global AI inference market, 87% of cloud computing, 95% of mobile operating systems, 78% of digital advertising, and 100% of the foundation model frontier. They extract data from 5 billion users, process it on hardware those users cannot access, and sell the resulting intelligence back as a subscription. The users who generate the data that trains the models that serve the users are never compensated, never consulted, and never given the option to run the models themselves. We name this pattern "AI colonialism" and trace its structural parallels to historical colonialism across 7 dimensions: resource extraction, dependency creation, infrastructure control, cultural imposition, knowledge gatekeeping, wealth concentration, and resistance suppression. We then present a decolonization framework with 5 concrete mechanisms: local inference (run the model yourself), data sovereignty (own your training data), open-weight models (no proprietary gatekeeping), mesh computing (collective infrastructure), and sovereign identity (you control who you are online). BlackRoad OS implements all five. We are not the only decolonization project — Ollama, Hugging Face, BOINC, Signal, and Mastodon each implement one or two. But we may be the first to implement all five in an integrated system.

## 1. The Colonial Pattern

### 1.1 Historical Colonialism (Simplified)

| Phase | Action | Mechanism | Outcome |
|-------|--------|-----------|---------|
| 1. Arrival | Discover resource-rich territory | Exploration, mapping | Knowledge of what to extract |
| 2. Extraction | Take resources without fair compensation | Mining, agriculture, labor | Wealth flows to colonizer |
| 3. Dependency | Install infrastructure that requires colonizer | Railways, ports, currency | Colony can't function independently |
| 4. Cultural replacement | Impose colonizer's language, religion, values | Schools, missionaries, laws | Colony loses indigenous capability |
| 5. Gatekeeping | Control access to knowledge, technology, markets | Education restrictions, trade monopolies | Colony can't develop independently |
| 6. Wealth concentration | Profits flow to colonizer's homeland | Trade policies, taxation | Growing inequality |
| 7. Resistance suppression | Prevent independence movements | Military, legal, economic pressure | Dependency maintained |

### 1.2 AI Colonialism (Mapped)

| Phase | Historical | Digital (2026) |
|-------|-----------|---------------|
| 1. Arrival | Colonizers map territory | Platforms map user behavior (cookies, tracking, fingerprinting) |
| 2. Extraction | Take minerals, crops, labor | Take data, attention, compute cycles (user generates training data for free) |
| 3. Dependency | Railways only go to ports | Cloud infrastructure only works with cloud platforms (vendor lock-in) |
| 4. Cultural replacement | Impose language, religion | Impose UX patterns, algorithmic values, platform norms ("the feed") |
| 5. Gatekeeping | Restrict education, technology | Restrict model weights (GPT-4 is closed), restrict compute (GPUs are expensive) |
| 6. Wealth concentration | Profits → colonizer homeland | Profits → 5 companies in California (combined market cap: $12 trillion) |
| 7. Resistance suppression | Military, legal, economic | Deplatforming, API pricing, patent litigation, regulatory capture |

### 1.3 The Numbers

| Resource | Who Generates It | Who Profits |
|----------|-----------------|-------------|
| Training data (text) | 5 billion internet users | OpenAI ($11B revenue), Google ($265B) |
| Training data (images) | Billions of photographers, artists | Midjourney ($200M), Stability AI |
| Training data (code) | 100M+ developers | GitHub Copilot ($2B ARR), Microsoft |
| Attention (7 hrs/day) | Every social media user | Meta ($135B), TikTok ($23B) |
| Compute (idle devices) | 22 billion idle devices | Nobody (wasted) |
| Personal data | Every platform user | Data broker industry ($300B) |

The pattern: users generate the raw material. Companies process it into products. Profits flow exclusively to the companies. Users pay again to access the products their data created.

## 2. The Seven Dimensions

### 2.1 Resource Extraction

**Historical**: British East India Company extracted tea, cotton, spices from India. Revenue: ~£400M/year (inflation-adjusted ~$40B).

**Digital**: Google extracts search queries (8.5 billion/day), Gmail reads emails (1.8 billion users), Maps tracks location (1 billion users). Revenue: $265B/year.

**The difference**: The East India Company needed ships and soldiers. Google needs a Terms of Service agreement and a "Sign in with Google" button. The extraction is frictionless, invisible, and consented to by users who have no practical alternative.

**Decolonization**: Self-hosted search (Searx, BlackRoad Search), self-hosted email (Maddy), local-first location (OsmAnd). The tools exist. The awareness doesn't.

### 2.2 Dependency Creation

**Historical**: Colonial railways in Africa were built from mines to ports — not connecting African cities to each other. The infrastructure served extraction, not development.

**Digital**: AWS services are designed to work with other AWS services. Google's APIs work best with Google's products. Apple's ecosystem locks users into Apple hardware. The infrastructure serves the platform, not the user.

**Specific mechanisms**:
- **Data format lock-in**: Google Docs uses a proprietary format. Exporting to .docx loses formatting.
- **API dependency**: Build on Twilio → dependent on Twilio pricing. Build on Stripe → dependent on Stripe terms.
- **Identity lock-in**: "Sign in with Google" means your identity IS Google's. Delete Google → lose access to everything.
- **Compute lock-in**: Train on AWS → model outputs are on AWS → serving requires AWS.

**Decolonization**: Open formats (Markdown, SQLite, JSON), self-hosted identity (RoadID), portable data (JSON export), commodity hardware (Raspberry Pi runs anywhere).

### 2.3 Infrastructure Control

**Historical**: British controlled India's telegraph system, railway system, and port system. Communication, transportation, and trade all required British infrastructure.

**Digital**: Five companies control the foundational infrastructure:

| Infrastructure | Controller | % Control |
|---------------|-----------|----------|
| Cloud compute | AWS + Azure + GCP | 66% |
| Mobile OS | iOS + Android | 99.6% |
| Browser engine | Chromium + WebKit | 93% |
| DNS resolution | Cloudflare + Google + AWS | 54% |
| TLS certificates | Let's Encrypt + DigiCert | 70% |
| AI inference | OpenAI + Google + Anthropic + Meta | ~92% |
| Code hosting | GitHub (Microsoft) | 90%+ |

**Decolonization**: Self-hosted everything. BlackRoad OS runs its own DNS (PowerDNS), TLS (Caddy/Let's Encrypt), compute (Pi fleet), AI (Ollama), code hosting (Gitea), and object storage (MinIO). Total dependence on external infrastructure: Cloudflare DNS (free tier) + 2 VPS ($30/month) + domain registrars.

### 2.4 Cultural Imposition

**Historical**: Colonial powers imposed their language, religion, legal system, and social norms. Indigenous languages, religions, and customs were suppressed.

**Digital**: Platforms impose their values through algorithmic curation:

| Platform Value | Imposed Through | User Impact |
|---------------|----------------|-------------|
| "Engagement is good" | Algorithmic feed, notifications | Addiction, attention fragmentation |
| "Sharing is normal" | Default-public posting, social pressure | Privacy erosion |
| "Growth is success" | Follower counts, viral metrics | Social comparison, anxiety |
| "Speed is quality" | Instant delivery, real-time everything | Impatience, shallow thinking |
| "Free is fair" | Ad-supported model, "free" products | Data exploitation normalized |

These are not neutral defaults — they are value systems that serve platform economics. "Engagement is good" serves advertising revenue. "Sharing is normal" serves data collection. "Growth is success" serves network effects.

**Decolonization**: Anti-persuasion architecture. No algorithmic feed. No engagement metrics. No public follower counts. Content has endpoints. Sessions have boundaries. The platform's values are: sovereignty, privacy, honesty, and utility. These are imposed too — but they serve the user, not the platform.

### 2.5 Knowledge Gatekeeping

**Historical**: Colonial powers restricted education for colonized peoples. The knowledge needed to build railways, ships, and factories was kept in European universities.

**Digital**: The knowledge needed to build AI is gatekept through:

| Gate | What It Blocks | Who Benefits |
|------|---------------|-------------|
| Closed model weights | Can't run GPT-4 yourself | OpenAI ($11B), users pay per token |
| GPU pricing ($10K+ per card) | Can't train models | NVIDIA ($47.5B GPU revenue) |
| Paper paywalls ($30/paper) | Can't read research | Elsevier ($4.2B revenue) |
| Compute costs ($100K+ per training run) | Can't reproduce results | Well-funded labs only |
| Talent concentration (Bay Area) | Can't hire ML engineers | FAANG salary premium |

The result: the 5 companies that control AI also control access to the knowledge needed to build AI alternatives.

**Decolonization**: Open-weight models (Meta Llama, Google Gemma, Microsoft Phi), open research (arXiv, Semantic Scholar), commodity inference hardware (Hailo-8, $50), and AI-assisted learning (the AI itself teaches you how to use it).

### 2.6 Wealth Concentration

**Historical**: Colonial wealth flowed from colonies to imperial capitals. London, Paris, and Amsterdam were built with colonial extracted wealth.

**Digital**: AI wealth flows to 5 zip codes in California:

| Company | HQ | Market Cap (2026) | Revenue | Employees |
|---------|-----|-------------------|---------|-----------|
| Apple | Cupertino | $3.5T | $390B | 161K |
| Microsoft | Redmond | $3.2T | $245B | 228K |
| Alphabet | Mountain View | $2.2T | $340B | 187K |
| Amazon | Seattle | $2.0T | $620B | 1.5M |
| Meta | Menlo Park | $1.5T | $165B | 67K |
| **Total** | **California** | **$12.4T** | **$1.76T** | **2.1M** |

$12.4 trillion of market cap, $1.76 trillion of annual revenue, concentrated in 5 companies employing 2.1 million people out of 5 billion digital users. That's 0.04% of the digital population controlling effectively all of the digital economy.

**Decolonization**: Distribute compute to the edge ($80 per node), distribute value through token economies (RoadCoin), distribute knowledge through open models (free inference), and distribute infrastructure through mesh networking (every device is a node).

### 2.7 Resistance Suppression

**Historical**: Independence movements were met with military force, economic sanctions, and political manipulation.

**Digital**: Sovereignty movements are met with:

| Resistance | Suppression Mechanism |
|-----------|----------------------|
| Self-hosting email | Gmail marks self-hosted email as spam |
| Alternative app stores | Apple sues to prevent sideloading (until DMA) |
| Federated social (Mastodon) | Platforms block federation, refuse interop |
| Ad-blocking | Websites block ad-block users, Chrome limits extensions |
| VPN usage | Streaming services block VPN IPs |
| Open-source AI | Regulatory proposals to restrict open model release |
| Right to repair | Apple, John Deere lobby against repair legislation |
| Data portability | Platforms offer export but make import impossible |

**Decolonization**: Build systems that don't need permission. WireGuard VPN doesn't ask Cloudflare for permission. Ollama doesn't ask OpenAI for permission. Gitea doesn't ask GitHub for permission. PS-SHA∞ doesn't ask anyone for permission.

## 3. The Decolonization Framework

### 3.1 Five Mechanisms

| Mechanism | What It Does | Who Implements It |
|-----------|-------------|------------------|
| **Local inference** | Run AI models on your own hardware | Ollama, llama.cpp, BlackRoad |
| **Data sovereignty** | Own and control your data | Nextcloud, Syncthing, BlackRoad |
| **Open-weight models** | No proprietary gatekeeping of AI | Meta (Llama), Google (Gemma), Microsoft (Phi) |
| **Mesh computing** | Collective infrastructure without platforms | BOINC, BlackRoad Mesh, Helium |
| **Sovereign identity** | You control who you are online | DID, Solid, RoadID, BlackRoad |

### 3.2 BlackRoad's Implementation

| Mechanism | BlackRoad Implementation | Status |
|-----------|------------------------|--------|
| Local inference | Ollama + Hailo-8 on Pi fleet | Working (8 models) |
| Data sovereignty | PS-SHA∞ journals, D1, self-hosted PostgreSQL | Working (5,249 entries) |
| Open-weight models | Exclusively Llama, Phi, Gemma | Working (no closed models) |
| Mesh computing | Browser mesh + device enrollment | POC (not production) |
| Sovereign identity | RoadID (hash-chain identity) | Working (18 agents) |

BlackRoad is the only project that implements all five mechanisms in an integrated system. Other projects implement one or two:
- **Ollama**: Local inference only
- **Nextcloud**: Data sovereignty only
- **Mastodon**: Federated identity only
- **BOINC**: Mesh computing only
- **Signal**: Encrypted communication only

## 4. The Counter-Arguments

### 4.1 "Colonialism Involved Violence. This Is Just Business."

True. Digital platform dominance does not involve physical violence, forced labor, or slavery. The analogy is structural, not moral. We are not equating data extraction with human suffering.

The structural parallel is: resource extraction → dependency creation → wealth concentration → resistance suppression. This pattern can occur with or without violence. The absence of violence does not make the pattern benign.

### 4.2 "Users Consent to Terms of Service."

Consent requires alternatives. When 99.6% of mobile OS is iOS/Android, "consent" to Google/Apple terms is not meaningful consent — it is the only option. When Gmail has 1.8 billion users and self-hosted email gets marked as spam, "choosing" Gmail is not a free choice.

Consent also requires understanding. Nobody reads Terms of Service (97% click "accept" without reading, per Deloitte). Consent without comprehension is not informed consent.

### 4.3 "Open Models Are Getting Better. The Market Is Self-Correcting."

Partially true. Meta, Google, and Microsoft release open-weight models for strategic reasons (ecosystem control, developer goodwill, competitive pressure on OpenAI). This is welcome but not sufficient:

- Open WEIGHTS are not open TRAINING DATA (we don't know exactly what Llama was trained on)
- Open MODELS are not open COMPUTE (training a 70B model still costs $1M+)
- Open INFERENCE is not open GOVERNANCE (Meta can stop releasing Llama at any time)

The market is partially self-correcting. Sovereign infrastructure ensures you benefit from the correction without depending on its continuation.

### 4.4 "Sovereign Infrastructure Is for Privileged Technical Users."

True today. Self-hosting requires technical knowledge that most people don't have. This is the same argument used against public libraries ("books are for the educated"), public education ("learning is for the wealthy"), and personal computing ("computers are for specialists").

Every democratization follows the same arc: specialist → prosumer → mainstream. Self-hosting in 2026 is in the "prosumer" phase. The "mainstream" phase requires the UX breakthrough that makes sovereignty as easy as signing up for Gmail.

## 5. Conclusion

The colonial pattern repeats because it works — for the colonizer. Extract resources, create dependencies, control infrastructure, concentrate wealth. It worked for empires. It works for platforms.

The decolonization pattern also repeats: build alternative infrastructure, distribute capability, educate for independence, resist extraction. It worked for nations. It can work for digital users.

BlackRoad OS is one decolonization project among many. Ollama decolonizes inference. Mastodon decolonizes social. Signal decolonizes communication. Nextcloud decolonizes storage. Each addresses one dimension. BlackRoad attempts to address all seven — not because one project should do everything, but because an operating system IS everything, and sovereignty must be complete to be meaningful.

The fruit of knowledge is not forbidden. The platforms just charge admission.

## References

[1] Couldry, N. & Mejias, U.A. "The Costs of Connection: How Data Is Colonizing Human Life and Appropriating It for Capitalism." Stanford University Press, 2019.

[2] Kwet, M. "Digital Colonialism: US Empire and the New Imperialism in the Global South." Race & Class, 2019.

[3] Mohamed, S. et al. "Decolonial AI: Decolonial Theory as Sociotechnical Foresight in Artificial Intelligence." Philosophy & Technology, 2020.

[4] Zuboff, S. "The Age of Surveillance Capitalism." PublicAffairs, 2019.

[5] Fanon, F. "The Wretched of the Earth." 1961.

[6] Said, E. "Orientalism." Vintage Books, 1978.

[7] Statista. "Cloud Computing Market Share." 2025.

[8] StatCounter. "Mobile Operating System Market Share." 2025.

[9] NVIDIA. "FY2025 Annual Report." 2025.

[10] Amundson, A.L. "Digital Sovereignty as Infrastructure Policy." BlackRoad OS Technical Report, 2026.

[11] Amundson, A.L. "The Death of SaaS." BlackRoad OS Technical Report, 2026.

[12] Amundson, A.L. "Anti-Persuasion Architecture." BlackRoad OS Technical Report, 2026.
