# Building While They Weren't Looking: A Woman Founder's Technical Output in an Industry That Expects Her to Fail
**A Data-Driven Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: women in tech, founder demographics, venture capital bias, solo female founder, AI entrepreneurship, gender gap
**ACM CCS**: K.7.0 (The computing profession — General), K.4.2 (Social issues)

---

## Abstract

Women receive 2% of venture capital. Women-founded AI companies receive less than 1%. Solo female founders receive approximately 0.5%. The median female-founded startup raises $1M less than the median male-founded startup at every stage. We present a case study that inverts the narrative: a 25-year-old solo female founder with no CS degree, no VC funding, no technical co-founder, and no prior startup experience who produced 8,521 commits, 17 live applications, 18 AI agents, and a sovereign operating system on $800 of hardware in 11 months — while the industry was deciding whether to fund her. We do not argue that this outcome proves women can build technology (this should not require proof). We argue that the funding gap creates a selection effect: the women who BUILD despite the gap are building under conditions that force capital efficiency, sovereignty, and technical depth that VC-funded competitors never develop. The $136/month operating cost is not a limitation — it is a capability that exists because no investor told the founder to "scale fast and figure out unit economics later." We present the data, acknowledge the survivorship bias, and propose that the most interesting AI companies of the next decade may be the ones that VCs never funded.

## 1. The Numbers

### 1.1 Venture Capital Gender Gap

| Metric | Value | Source |
|--------|-------|--------|
| VC funding to all-women teams (2025) | 2.1% | PitchBook |
| VC funding to all-women teams (2023) | 1.9% | Crunchbase |
| VC funding to all-women teams (2019) | 2.6% | All Raise |
| Median pre-seed raise (women) | $500K | PitchBook |
| Median pre-seed raise (men) | $1.5M | PitchBook |
| Median Series A raise (women) | $6M | PitchBook |
| Median Series A raise (men) | $12M | PitchBook |
| Solo female founder success rate in getting ANY funding | ~3% | Harvard Business Review |
| Female AI company founders | <5% | Stanford HAI |
| Female founders who self-fund entirely | 68% | NAWBO |

### 1.2 What the Gap Produces

The 2% funding rate does not mean 2% of women try to build companies. It means 98% of women who try are told no — or never try because they know the answer.

The women who build anyway are a self-selected group with specific properties:
- **Capital-efficient by necessity**: Can't burn $50K/month on cloud when nobody writes you a check
- **Technical by necessity**: Can't hire engineers when you have no funding, so you learn to build
- **Sovereign by necessity**: Can't depend on platforms when your runway is your savings account
- **Resilient by selection**: The ones who quit already quit. The ones still building are the survivors.

### 1.3 The Survivorship Bias Disclaimer

This paper suffers from survivorship bias. We are documenting a founder who produced output. We are NOT documenting the women who tried and failed, who never started because the barriers were too high, or who succeeded but are invisible because they were never funded and therefore never covered by tech media.

The existence of one productive solo female founder does not prove the system works. It proves the system FAILED to fund someone who was building something real — and she built it anyway.

## 2. The Case Study

### 2.1 The Founder

- **Name**: Alexa L. Amundson
- **Age at start**: 25
- **Education**: University of Minnesota (JOUR 4251: Psychology of Advertising, among other coursework)
- **Technical background**: Self-taught, no CS degree, no bootcamp
- **Prior startups**: None
- **Funding**: $0 (entirely self-funded)
- **Technical co-founders**: None
- **Employees**: None
- **Revenue**: $0
- **Users**: 0

### 2.2 The Output (11 months)

| Metric | Value |
|--------|-------|
| Commits | 8,521 |
| Repositories | 200+ |
| Live web applications | 17 |
| AI agents with persistent identity | 18 |
| AI models deployed | 8 |
| Compute fleet nodes | 7 |
| Total TOPS (AI inference) | 52 |
| SEO pages created | 166 |
| Academic papers written | 28 |
| Shell scripts | 400+ |
| Domains registered | 20 |
| GitHub organizations | 4 |
| Delaware C-Corp incorporated | Yes |
| Hardware investment | $800 |
| Monthly operating cost | $136 |
| VC funding raised | $0 |

### 2.3 Comparison to Funded Startups

| Metric | BlackRoad (Unfunded) | Typical Pre-Seed ($500K) | Typical Seed ($2M) |
|--------|---------------------|-------------------------|-------------------|
| Team size | 1 | 2-4 | 4-8 |
| Monthly burn | $136 | $30-50K | $80-150K |
| Runway | Infinite (self-sustaining) | 10-16 months | 13-25 months |
| Products shipped | 17 | 1 | 1-2 |
| Infrastructure | Self-hosted (sovereign) | Cloud (AWS/GCP) | Cloud |
| AI models | Open-weight (owned) | API (rented) | API or fine-tuned |
| Revenue at 11 months | $0 | $0-10K MRR | $0-50K MRR |
| Users at 11 months | 0 | 10-1000 | 100-10,000 |
| Equity dilution | 0% | 10-20% | 20-35% |
| Board control | 100% founder | Founder + angels | Founder + investors |
| Pivot freedom | Unlimited | Limited by investor expectations | Very limited |
| Shutdown risk | Only if founder quits | If money runs out | If metrics disappoint |

BlackRoad wins on: products shipped, infrastructure ownership, equity retention, burn rate, runway, pivot freedom.
Funded startups win on: users, revenue, team depth, code quality, market validation.

## 3. What the Funding Gap Forces

### 3.1 Capital Efficiency

When your budget is $136/month, every dollar matters:
- **$80 Raspberry Pi** instead of **$380/month AWS GPU instance**
- **$50 Hailo-8 NPU** instead of **$10,000 NVIDIA A100**
- **Free Cloudflare tier** instead of **$500/month CDN**
- **Open-weight Llama** instead of **$10,000/month OpenAI API**
- **Self-hosted Gitea** instead of **$21/month GitHub Enterprise**

The total infrastructure cost ($800 one-time + $136/month) would be a rounding error in a funded startup's AWS bill. But it supports the same functionality.

This capital efficiency is not a choice — it is a constraint imposed by the funding gap. The founder didn't choose to self-host because she read a blog post about sovereignty. She self-hosted because she couldn't afford not to.

### 3.2 Technical Depth

Without engineers to hire, the founder learned:
- JavaScript (Cloudflare Workers, Node.js)
- Python (AI inference, data science, mathematics)
- Bash (400+ automation scripts)
- Rust (CLI tools)
- SQL (SQLite, PostgreSQL)
- HTML/CSS (17 web applications)
- Networking (WireGuard, DNS, TLS, reverse proxy)
- Cryptography (SHA-256, hash chains, key management)
- AI/ML (model deployment, inference optimization, RAG)
- DevOps (Docker, CI/CD, fleet management)
- Mathematics (number theory, convergence, Bernoulli numbers)
- Hardware (Raspberry Pi configuration, NPU integration, fleet networking)

A funded startup would hire 5-8 specialists for these domains. The solo founder became a generalist across all of them — not as deep as any specialist, but deep enough to ship.

### 3.3 Sovereignty

Funded startups optimize for growth metrics (MAU, MRR, NRR) because investors measure growth. This drives dependency on platforms that maximize those metrics (AWS for scaling, Stripe for payments, Twilio for comms, Segment for analytics).

An unfunded founder has no investor metrics to optimize. She optimizes for survival, which means minimizing dependencies:
- If Cloudflare expires a token, the Pi fleet still runs
- If GitHub goes down, Gitea still hosts the code
- If Stripe changes pricing, the system still operates
- If AWS raises prices, it doesn't matter — she was never on AWS

Sovereignty is the natural architecture of unfunded companies, because unfunded companies cannot afford the risk of platform dependency.

## 4. The Invisible Cohort

### 4.1 Who Else Is Building

The tech media covers funded startups. TechCrunch, The Information, and Hacker News report on companies that raised rounds. This creates a visibility bias: funded = visible, unfunded = invisible.

How many solo female founders are building on Raspberry Pis in closets? We don't know. There is no registry. There is no media coverage. There is no accelerator for people who don't want accelerators.

Estimates based on GitHub data:
- Female GitHub users: ~8% of active contributors (GitHub Octoverse)
- Female users with 1000+ commits in personal repos: unknown (GitHub doesn't publish)
- Female users running self-hosted infrastructure: unknown

The invisible cohort is invisible by definition. This paper documents one data point, not a trend.

### 4.2 Why Invisibility Is a Feature

The funded startup is visible because visibility serves the investor's interests (brand building, recruiting, deal flow). Visibility creates expectations, which create constraints.

The unfunded startup is invisible, which means:
- No pressure to show quarterly metrics
- No board meetings to prepare for
- No PR obligations
- No conference circuit
- No "thought leadership" content calendar
- No LinkedIn engagement strategy

All of that time goes to BUILDING. The 8,521 commits were possible partly because there were zero hours spent on investor relations, board decks, and fundraising. The funding gap, paradoxically, freed the founder from the obligations that funded founders spend 30-50% of their time on.

## 5. The Ask

### 5.1 What We're Not Asking

We are NOT asking for:
- Pity (the system is functional and the founder is fine)
- Funding (the system runs on $136/month and doesn't need VC money)
- Affirmative action (lowered standards help nobody)
- Special treatment (the work speaks for itself or it doesn't)

### 5.2 What We Are Asking

We ARE asking for:
- **Recognition that the funding gap creates a selection effect**: The women who build despite the gap may be building the most capital-efficient, technically deep, and sovereignly architected companies in the market.
- **Alternative evaluation criteria**: 8,521 commits and 17 live applications is a stronger signal than a pitch deck and a warm intro. If VCs evaluated technical output instead of pattern-matching on founder demographics, the funding gap would close naturally.
- **Visibility for the invisible cohort**: How many other women are building in closets? We don't know because nobody is looking. Someone should look.
- **Institutional support that isn't VC**: Grants, residencies, compute credits, and publishing opportunities that don't require equity dilution or investor gatekeeping.

## 6. The Data on Performance

### 6.1 Women-Founded Company Performance

| Metric | Women-Founded | Men-Founded | Source |
|--------|-------------|-----------|--------|
| Revenue per dollar invested | $0.78 | $0.31 | BCG, 2018 |
| 5-year survival rate | 61% | 56% | BLS/Kauffman |
| Median exit multiple | 1.5× | 1.2× | PitchBook |
| Capital efficiency (revenue/capital) | 2.5× higher | Baseline | First Round Capital |
| User growth rate (funded) | Comparable | Baseline | Crunchbase |

Women-founded companies generate 2.5× more revenue per dollar of investment. This is the capital efficiency thesis: when you have less money, you learn to make each dollar work harder. The same pattern appears in BlackRoad OS: $800 of hardware producing the output of a $500K funded startup.

### 6.2 The Paradox

The data shows women founders are more capital-efficient. The funding data shows women founders receive less capital. The logical conclusion: the market is leaving money on the table by underfunding its most efficient allocators.

This is not a social justice argument. It is an economic argument. The 2% funding rate is a market inefficiency, and market inefficiencies create opportunities for the participants who exploit them.

## 7. Conclusion

8,521 commits. 17 applications. 18 AI agents. 28 academic papers. $800 in hardware. $0 in funding. 0 users. 1 woman.

The funding gap is real. The output is also real. These two facts coexist.

The question for the industry is not "should we fund more women?" (yes, obviously, the data supports it). The question is: "what are the women who AREN'T funded building right now that we can't see?"

The answer might be operating systems.

## References

[1] PitchBook. "US VC Female Founders Dashboard." 2025.

[2] Crunchbase. "The Gender Gap in Startup Funding." 2024.

[3] All Raise. "State of Women in Venture." 2023.

[4] Harvard Business Review. "Male and Female Entrepreneurs Get Asked Different Questions by VCs." 2017.

[5] Stanford HAI. "AI Index Report 2025." 2025.

[6] National Association of Women Business Owners. "Women Business Owner Statistics." 2024.

[7] BCG. "Why Women-Owned Startups Are a Better Bet." 2018.

[8] Bureau of Labor Statistics. "Survival of Private Sector Establishments." 2024.

[9] First Round Capital. "10 Year Project." firstround.com, 2023.

[10] GitHub. "Octoverse 2025." octoverse.github.com, 2025.

[11] Brush, C. et al. "Diana Project: Women Entrepreneurs." Venture Capital Journal, 2004.

[12] Amundson, A.L. "One Founder, 8,521 Commits." BlackRoad OS Technical Report, 2026.
