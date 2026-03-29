# Viral Open Source Repo Research (2023-2025)

Research compiled March 2026 from actual GitHub API data, ROSS Index, TechCrunch, arxiv papers, and direct repo analysis.

---

## PART 1: THE SCOREBOARD (Ranked by 2024 Star Growth)

| Rank | Project | Stars Now | Stars Gained 2024 | Growth % | Created | Day-1 Files |
|------|---------|-----------|-------------------|----------|---------|-------------|
| 1 | **Ollama** | 166,354 | 76,100 | 261% | Jun 2023 | ~30 files |
| 2 | **Zed** | 52,100+ | 52,100 | N/A (went OS Jan 2024) | 2021 | N/A |
| 3 | **Dify** | 134,835 | 43,400 | 326% | Apr 2023 | N/A |
| 4 | **ComfyUI** | 107,195 | 40,900 | N/A | Jan 2023 | N/A |
| 5 | **OpenHands** | 39,600+ | 39,600 | New in 2024 | 2024 | N/A |
| 6 | **LobeChat** | 50,500+ | 36,000 | N/A | N/A | N/A |
| 7 | **Stirling-PDF** | 75,877 | 34,700 | N/A | Jan 2023 | N/A |
| 8 | **Maybe Finance** | 34,700+ | 34,700 | New in 2024 | N/A | N/A |
| 9 | **uv (Astral)** | 82,217 | 34,100 | New in 2024 | Oct 2023 | N/A |
| 10 | **Screenshot-to-Code** | 66,300+ | 33,700 | N/A | N/A | N/A |
| - | **AutoGPT** | 182,916 | N/A (2023 peak) | 0-100K in weeks | Mar 2023 | **1 file** |
| - | **shadcn/ui** | 110,947 | ~30K est. | N/A | Jan 2023 | 315 files |
| - | **Excalidraw** | 119,715 | 27,000 | N/A | Jan 2020 | N/A |
| - | **Open Interpreter** | 62,893 | N/A (2023 peak) | N/A | Jul 2023 | 2 files |
| - | **CrewAI** | 47,428 | ~30K est. | N/A | Oct 2023 | **1 file** |
| - | **Bun** | 88,435 | ~15K est. | N/A | Apr 2021 | N/A |
| - | **Deno** | 106,443 | ~10K (hit 100K) | N/A | May 2018 | N/A |
| - | **Tailwind CSS** | 94,203 | ~18K est. | N/A | Oct 2017 | N/A |
| - | **Cursor** | 32,524 | N/A | N/A | Mar 2023 | N/A |
| - | **htmx** | 47,718 | ~15K est. | N/A | Apr 2020 | 2 files |
| - | **tldraw** | 46,090 | ~15K est. | N/A | May 2021 | N/A |
| - | **Pi-hole** | 56,314 | ~8K est. | N/A | Jun 2014 | N/A |
| - | **LocalAI** | 44,525 | ~15K est. | N/A | Mar 2023 | N/A |
| - | **Jan.ai** | 41,352 | 24,200 | Top 20 ROSS | Aug 2023 | N/A |
| - | **Coolify** | 52,322 | 25,900 | Top 20 ROSS | Jan 2021 | N/A |

Source: GitHub API (live data March 2026) + ROSS Index Annual 2024

---

## PART 2: DAY-1 REPO STRUCTURES (What the repo looked like on first commit)

### AutoGPT - THE fastest repo in GitHub history (0 to 100K stars in weeks)

**First commit: March 16, 2023**
**Total files: 1**

```
prompt.txt
```

That's it. One text file. The content was a prompt for "Entrepreneur-GPT" with a $100 starting balance and a list of available actions (Google Search, check news, commit to memory, start GPT-4 instances, navigate websites). It was literally a system prompt pasted into a text file.

By March 30, 2023 (14 days later), the repo had a Python script and README. Within weeks it had 100,000+ stars.

**Lesson: The idea was so compelling that one file was enough. The concept sold itself.**

---

### Ollama - #1 fastest growing in 2024 (76K stars gained)

**First commit: June 26, 2023**
**Total files: ~30**

```
.gitignore
LICENSE
README.md
build.py
model_prompts.json
ollama.py
requirements.txt
template.py
desktop/ (Electron app - ~20 files)
models/ (empty dir with README.txt)
```

The first README was simple:

```markdown
# ollama

(monkey emoji)

## Running
pip install -r requirements.txt
python3 ollama.py serve

## Building
(instructions for Apple silicon)

## API
GET /models
POST /generate
```

**Lesson: A Python script, a simple API, and a desktop app wrapper. No fancy docs, no badges, no marketing copy. Just "here's how to run it."**

---

### Open Interpreter - 0 to 50K+ stars in months

**First commit: July 14, 2023**
**Total files: 2** (LICENSE + README.md)

Second commit (same day) added:
```
.replit
interpreter/__init__.py
interpreter/exec.py
interpreter/interpreter.py
interpreter/json_utils.py
interpreter/openai_utils.py
interpreter/view.py
main.py
poetry.lock
pyproject.toml
setup.py
```

**Total: ~15 files on day 1.** A small Python package with 5 source files.

**Lesson: Minimal Python package. The "local Code Interpreter" concept was the viral hook.**

---

### CrewAI - 0 to 47K stars

**First commit: October 27, 2023**
**Total files: 1**

```
README.md
```

Content of first README:
```markdown
# CrewAI
```

Two words. That's the entire first commit.

**Lesson: Even less than AutoGPT. The code came later. The name and concept were registered first.**

---

### htmx - 0 to 47K stars

**First commit: April 13, 2020**
**Total files: 2**

```
LICENSE
README.md
```

Content of first README:
```markdown
# exhtml
Extended HTML
```

Originally called "exhtml." Two words. The viral growth came 3 years later in 2023 through meme marketing and YouTube creators.

**Lesson: Slow burn. 3 years of quiet building before viral explosion. Meme marketing worked.**

---

### shadcn/ui - 0 to 110K stars in 2 years

**First commit: January 24, 2023**
**Total files: 315**

This was NOT a minimal start. It launched as a full monorepo with:
- Next.js docs site (apps/www/)
- Multiple component examples
- Full configuration (.husky, .eslintrc, etc.)
- Fonts, styles, and a complete website

**Lesson: shadcn launched with a polished product. The "not a component library" concept was the differentiator, but the execution was professional from day 1.**

---

## PART 3: README STRUCTURES THAT WORK

### Pattern A: "Ultra-Minimal" (AutoGPT, CrewAI, htmx)
```
# Project Name
One-line description

## Quick Start
[2-3 commands]
```
Works when: The concept is so compelling it sells itself. People share the IDEA, not the README.

### Pattern B: "Clean & Functional" (Ollama current)
```
[Centered logo]
[Tagline: "Get up and running with LLMs"]

## Download
[Platform-specific one-liners]
  - macOS: curl | sh
  - Linux: curl | sh
  - Windows: PowerShell
  - Docker

## Quick Start
ollama run llama3

## REST API
[curl example]

## Community Integrations
[categorized list]
```
Works when: The tool needs to show instant value across platforms.

### Pattern C: "Hero Image + Minimal Text" (shadcn/ui current)
```
[Full-width hero image/screenshot]

[One paragraph description]

Documentation: [link]
Contributing: [link]
License: MIT
```
~150 words total. Pushes everything to the docs site. Works when: You have a beautiful product that speaks for itself visually.

### Pattern D: "Full Launch README" (Dify, ComfyUI)
```
[Logo + badges]
[Hero screenshot/GIF]

## Features
[Bulleted highlights]

## Quick Start
[Docker one-liner or curl]

## Cloud vs Self-Hosted
[Comparison]

## Documentation
[Links]

## Community
[Discord/Twitter/etc.]

## Star History
[Chart]
```

---

## PART 4: WHAT MADE PEOPLE SHARE EACH PROJECT

### Ollama
- **The hook**: "Run LLMs locally with one command"
- **Shareability**: `curl -fsSL https://ollama.com/install.sh | sh` then `ollama run llama3` -- TWO commands to AI
- **Why it spread**: Privacy/sovereignty narrative + dead simple UX + no GPU required for small models
- **Growth trajectory**: 29K stars Q1 2024, 105K by end of 2024 (76K gained in one year)

### AutoGPT
- **The hook**: "Autonomous AI agent that can do anything"
- **Shareability**: The CONCEPT was viral, not the code. "AI that runs itself" was irresistible to share
- **Why it spread**: GPT-4 had just launched. People were terrified/excited about autonomous AI. Perfect timing.
- **Growth trajectory**: 0 to 100K stars in WEEKS. Fastest GitHub repo ever at the time.

### shadcn/ui
- **The hook**: "Not a component library. Copy-paste components you OWN."
- **Shareability**: Anti-pattern to npm install. Developers frustrated with breaking changes loved this.
- **Why it spread**: Vercel sponsorship + v0 AI integration + AI tools defaulting to shadcn
- **Growth trajectory**: 0 to 100K+ in 2.5 years. Steady climb, not spike.

### Cursor
- **The hook**: "AI code editor that actually works"
- **Shareability**: "Wow moments" -- people built entire apps and shared videos. An 8-year-old coding video went viral.
- **Why it spread**: Word of mouth from engineers at OpenAI, Midjourney, Perplexity. $1M to $100M ARR in one year.
- **Growth trajectory**: Viral coefficient of 1.4 (each user brings 1.4 more users)

### htmx
- **The hook**: "HTML is the programming language. No JavaScript frameworks needed."
- **Shareability**: MEME MARKETING. The htmx team intentionally used humor and anti-framework jokes.
- **Why it spread**: ThePrimeagen and Fireship YouTube videos. Counter-culture to React/Angular/Vue complexity.
- **Growth trajectory**: Slow build 2020-2022, then explosive 2023 via content creators.

### Bun
- **The hook**: "JavaScript runtime that's insanely fast"
- **Shareability**: Speed benchmarks. Everyone shared the benchmark charts showing Bun destroying Node.js.
- **Why it spread**: Performance porn. Developers love sharing "X is 10x faster than Y."
- **Growth trajectory**: 20K stars in first week of beta. 88K total.

### uv (Astral)
- **The hook**: "pip but written in Rust, 10-100x faster"
- **Shareability**: Speed benchmarks again. "Install 1000 packages in 2 seconds."
- **Why it spread**: Every Python developer has waited for pip. Astral already had credibility from Ruff.
- **Growth trajectory**: 0 to 82K in ~18 months. Rocket ship.

### Dify
- **The hook**: "Visual LLM app builder, no code required"
- **Shareability**: Screenshots of the visual workflow editor. "Build AI apps without writing code."
- **Why it spread**: Enterprise demand + low barrier to entry + 130K+ apps created on their cloud
- **Growth trajectory**: 326% growth in 2024, hit 100K stars.

### Stirling-PDF
- **The hook**: "Self-hosted PDF tool that does EVERYTHING"
- **Shareability**: "Finally, a PDF tool that doesn't require Adobe or uploading files to sketchy websites"
- **Why it spread**: Privacy angle + universal need (everyone needs PDF tools) + 50+ operations
- **Growth trajectory**: 0 to 75K. Picked up by self-hosted community.

### Coolify
- **The hook**: "Self-hosted Vercel/Heroku/Netlify alternative"
- **Shareability**: "Deploy anything on your own server. No vendor lock-in."
- **Why it spread**: Sovereignty movement + Heroku free tier death + 280+ one-click services
- **Growth trajectory**: Slow build 2021-2023, explosive 2024 (25.9K new stars).

### Excalidraw
- **The hook**: "Free whiteboard that looks hand-drawn"
- **Shareability**: People shared their diagrams, which automatically advertised the tool
- **Why it spread**: Remote work boom + beautiful output + no login required
- **Growth trajectory**: Steady climb from 2020. 27K new stars in 2024. Now 119K total.

---

## PART 5: THE INSTALL EXPERIENCE PATTERNS

### Tier 1: One-liner installs (highest conversion)
```bash
# Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Bun
curl -fsSL https://bun.sh/install | bash

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Deno
curl -fsSL https://deno.land/install.sh | sh
```

### Tier 2: Package manager installs
```bash
# Ollama
brew install ollama

# Tailwind CSS
npm install -D tailwindcss

# Pi-hole
curl -sSL https://install.pi-hole.net | bash
```

### Tier 3: Docker one-liners
```bash
# Stirling-PDF
docker run -p 8080:8080 stirlingtools/stirling-pdf

# Coolify
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Dify
docker compose up -d
```

### Tier 4: CLI tools (shadcn pattern)
```bash
npx shadcn@latest init
npx shadcn@latest add button
```

**Key insight: Every viral project has a "time to value" under 60 seconds. One command to install, one command to see results.**

---

## PART 6: WHAT ACTUALLY MAKES A README GO VIRAL

### Research-backed findings (from arxiv papers and case studies):

1. **The 30-second rule**: Your README needs to grab attention in 30 seconds and help users achieve something tangible within 10 minutes.

2. **Visual proof matters more than words**: A GIF or screenshot of the product working beats any amount of text. "Humans are inherently visual creatures."

3. **Logo + Badges + One-liner**: The heading captures most readers' attention. Fail here and you lose them forever.

4. **The install must be copy-pasteable**: If someone can't copy one command and see results, you lose them.

5. **Hacker News timing**: Posts at 12-17 UTC get ~200 more stars than poorly-timed posts. Average HN front page post gains 121 stars in 24 hours, 289 in 7 days.

6. **Pre-launch social proof**: Getting 100 stars before public launch (through direct networking) creates credibility that compounds.

7. **Tuesday-Wednesday launches outperform weekends**.

8. **The concept must be tweetable**: If you can't explain it in one sentence, it won't spread. Every viral repo has a one-sentence hook.

---

## PART 7: THE LAUNCH PLAYBOOK (Battle-tested, grew AFFiNE from 0 to 33K stars)

### Timeline:
| When | Action |
|------|--------|
| T-4 weeks | Strategy, positioning, one-line value prop |
| T-3 weeks | README, landing page, documentation |
| T-2 weeks | Outreach to content creators/KOLs |
| T-1 week | Final coordination, team assignments |
| T-0 | Multi-channel simultaneous launch |
| T+1 to T+7 | Daily engagement, momentum maintenance |

### Channels ranked by impact:
1. **Hacker News** - hundreds of stars in hours if you hit front page
2. **Reddit** (r/programming, r/selfhosted, r/webdev, etc.)
3. **Twitter/X** - content creators sharing demos
4. **YouTube** - Fireship, ThePrimeagen, etc. (htmx owes its growth to this)
5. **Product Hunt** - good for visibility but lower star conversion (~10 stars per 193 visits)
6. **DEV.to** - long-form articles showing the "why"
7. **V2EX** - critical for Chinese developer audience

### Key principle:
"Stars without strategy are vanity metrics. Stars with intent are business drivers."

---

## PART 8: PATTERNS ACROSS ALL VIRAL REPOS

### What they ALL have in common:

1. **Solves one clear problem**: Not a platform, not an ecosystem. ONE thing, done well.
   - Ollama: run LLMs locally
   - shadcn: own your components
   - htmx: HTML without JS frameworks
   - Bun: fast JS runtime
   - uv: fast Python packages

2. **The name is short and memorable**: Ollama, Bun, Dify, htmx, Zed, uv

3. **Install in one command, value in under 60 seconds**

4. **Counter-positioning**: Almost every viral repo is positioned AGAINST something:
   - Ollama vs. OpenAI API (local vs. cloud)
   - shadcn vs. npm packages (own vs. depend)
   - htmx vs. React (HTML vs. JavaScript)
   - Bun vs. Node (fast vs. slow)
   - Coolify vs. Vercel (self-hosted vs. vendor)
   - Stirling-PDF vs. Adobe (free vs. paid)

5. **The first version is TINY**: AutoGPT was 1 file. CrewAI was 1 file. htmx was 2 files. Open Interpreter was 15 files. Ollama was ~30 files. Ship small, ship fast.

6. **Timing with a cultural moment**:
   - AutoGPT: GPT-4 launch week
   - Ollama: privacy/sovereignty movement + local AI wave
   - Coolify: Heroku kills free tier
   - ComfyUI: Stable Diffusion explosion
   - Bun: Node.js fatigue

7. **The concept is shareable as a sentence**:
   - "This repo went from $100 to autonomous AI"
   - "Run any LLM on your laptop with one command"
   - "Not a component library - you OWN the code"
   - "HTML is the programming language"

---

## SOURCES

- [ROSS Index Annual 2024 - Runa Capital](https://runacap.com/ross-index/annual-2024/)
- [TechCrunch: 20 Hottest Open Source Startups of 2024](https://techcrunch.com/2025/03/22/the-20-hottest-open-source-startups-of-2024/)
- [AutoGPT Wikipedia](https://en.wikipedia.org/wiki/AutoGPT)
- [Shadcn is the #1 UI Library on GitHub](https://growingproducts.substack.com/p/shadcn-is-the-1-ui-library-on-github)
- [Why shadcn/ui is taking over the internet](https://www.haydenbleasel.com/blog/shadcn)
- [How Cursor AI Hacked Growth](https://www.productgrowth.blog/p/how-cursor-ai-hacked-growth)
- [Launch-Day Diffusion: HN Impact on GitHub Stars (arxiv)](https://arxiv.org/html/2511.04453v1)
- [GitHub Star Growth Launch Playbook](https://dev.to/iris1031/github-star-growth-a-battle-tested-open-source-launch-playbook-35a0)
- [How to Get Your First 1000 GitHub Stars](https://dev.to/iris1031/how-to-get-your-first-1000-github-stars-the-complete-open-source-growth-guide-4367)
- [How to Write a 4000 Stars GitHub README](https://www.daytona.io/dotfiles/how-to-write-4000-stars-github-readme-for-your-project)
- [The State of HTMX 2024](https://hamy.xyz/blog/2024-09_the-state-of-htmx)
- [Cursor AI Statistics 2026](https://gitnux.org/cursor-ai-statistics/)
- [CrewAI 44K Stars Growth](https://theagenttimes.com/articles/44335-stars-and-counting-crewais-github-surge-maps-the-rise-of-the-multi-agent-e)
- [Dify 100K Stars](https://dify.ai/blog/100k-stars-on-github-thank-you-to-our-amazing-open-source-community)
- [Bun Story: From Frustration to Billion-Dollar Infrastructure](https://chyshkala.com/blog/the-bun-story)
- [GitHub Octoverse 2024](https://github.blog/news-insights/octoverse/octoverse-2024/)
