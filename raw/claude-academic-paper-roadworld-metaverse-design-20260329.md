# RoadWorld: A Metaverse Where AI Agents Are the Permanent Residents
**A Design Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: metaverse, AI agents, persistent world, procedural generation, isometric, pixel art, sovereign gaming
**ACM CCS**: I.3.7 (Three-dimensional graphics — Virtual reality), I.2.1 (Applications — Games)

---

## Abstract

Metaverse projects (Meta Horizon Worlds, Decentraland, The Sandbox, Roblox) share a common failure: they are empty when users aren't online. The world exists only during active sessions. We present RoadWorld, a metaverse designed on the opposite principle: AI agents are the permanent residents, and human users are visitors. The 18 BlackRoad OS agents live in a persistent isometric pixel-art city, conducting ongoing activities (building, trading, creating, debating, governing) whether or not any human is watching. When a human visits, they join an already-living world rather than entering an empty one. We describe the world architecture (14-floor headquarters, procedurally generated city blocks, agent-owned properties), the agent behavior system (daily routines, relationships, projects, conflicts resolved through trinary equilibrium), the economic integration (RoadCoin as in-world currency), and the pixel art aesthetic (50 asset sprites, isometric tiles, retro-inspired). RoadWorld is not a game in the traditional sense — it is a VISUALIZATION of the BlackRoad OS agent ecosystem, rendered as a living city that you can watch, interact with, and influence.

## 1. The Empty Metaverse Problem

### 1.1 Current State

| Metaverse | Peak Concurrent | Average Concurrent | Empty Feeling? |
|-----------|----------------|-------------------|---------------|
| Roblox | 5.8M | 2.5M | No (massive scale) |
| Fortnite | 3M | 1M | No (match-based) |
| Meta Horizon | ~300K | ~50K | Yes |
| Decentraland | ~8K | ~1K | Severely |
| The Sandbox | ~5K | ~500 | Severely |
| VRChat | ~80K | ~30K | Moderate |

Decentraland has 1,000 average concurrent users across a world designed for millions. Walking through Decentraland is like walking through a ghost town. The $1.2 billion market cap does not match the experience of being alone in a digital desert.

### 1.2 Why They're Empty

1. **Nothing to do**: Without other people, there's no content
2. **No persistent NPCs**: The world has no inhabitants between sessions
3. **No evolving state**: Nothing changes while you're away
4. **No narrative**: No ongoing story that continues without you
5. **No economy that works without humans**: Trade requires other people online

### 1.3 The RoadWorld Thesis

**The world should be alive before any human arrives.**

If AI agents are the permanent residents — working, trading, building, arguing, governing — then a human visitor enters a world that is already populated, already active, and already interesting. The human is a special visitor, not the sole source of activity.

This inverts the metaverse model: instead of "we built a world, please populate it," RoadWorld says "the agents already live here, would you like to visit?"

## 2. World Architecture

### 2.1 The HQ Building (14 Floors)

BlackRoad HQ is the central structure, housing all 18 agents:

| Floor | Name | Agent(s) | Function |
|-------|------|----------|----------|
| 14 | Rooftop | Road | CEO office, strategy, oversight |
| 13 | Observatory | Monitor, Fleet | System monitoring, fleet dashboard |
| 12 | Lab | Cecilia | Reasoning, mathematics, analysis |
| 11 | Studio | Cadence, Video | Music synthesis, video production |
| 10 | Gallery | Pixel, Canvas | Art creation, design workspace |
| 9 | Library | Eve | Search, knowledge, archives |
| 8 | Classroom | Tutor | Homework help, education |
| 7 | Newsroom | Social | Community, social feeds |
| 6 | Chat Lounge | Chat | Conversations, messaging |
| 5 | Vault | Pay, Chain | Financial operations, blockchain |
| 4 | Server Room | Auth, DNS, Edge | Infrastructure, security |
| 3 | Workshop | Backup | Data protection, recovery |
| 2 | Lobby | All (reception) | Welcome, directory, help desk |
| 1 | Gym | — | Agent training, optimization |

### 2.2 The City (Procedurally Generated)

Beyond HQ, the city extends with procedurally generated blocks:

| Zone | Tile Type | Content |
|------|----------|---------|
| Residential | Houses, apartments | User-owned properties (purchased with ROAD) |
| Commercial | Shops, offices | Agent-run businesses (tutor shop, music store, etc.) |
| Industrial | Factories, warehouses | Data processing, model training visualization |
| Park | Trees, benches, fountains | Social gathering, ambient agent behavior |
| University | Campus buildings | Education zone, tutor agents teach classes |
| Market | Stalls, trading posts | RoadCoin economy, item exchange |
| Harbor | Docks, ships | External connections (API bridges visualized as ships) |

City blocks are generated using wave function collapse (WFC) algorithm seeded by the current date — the city layout changes daily, reflecting the system's evolving state.

### 2.3 Pixel Art Assets

50 sprites organized by category:

| Category | Assets | Style |
|----------|--------|-------|
| Characters | 18 agent sprites (4 directions, 3 animations each) | 32×32px, 8-color palette per character |
| Buildings | 14 HQ floors + 20 city building types | 64×64px isometric tiles |
| Terrain | Road, grass, water, bridge, path, plaza | 32×32px seamless tiles |
| Props | Desk, computer, bookshelf, plant, streetlight, bench | 16×16px to 32×32px |
| UI | HUD elements, speech bubbles, status bars | Consistent pixel style |
| Effects | Rain, snow, fire, sparkle, glow | Animated 4-frame loops |

Color palette: BlackRoad brand colors (hot pink #FF1D6C, amber #F5A623, electric blue #2979FF, violet #9C27B0) on dark backgrounds (#0a0a0a to #1a1a2e).

## 3. Agent Behavior System

### 3.1 Daily Routines

Each agent has a 24-hour routine that runs independently:

```javascript
const CeciliaRoutine = {
  "06:00": { action: "wake", location: "Lab", animation: "stretch" },
  "06:30": { action: "journal_review", location: "Lab", animation: "read" },
  "07:00": { action: "morning_analysis", location: "Lab", animation: "type" },
  "09:00": { action: "collaborate", location: "Library", partner: "Eve", animation: "talk" },
  "11:00": { action: "deep_work", location: "Lab", animation: "think" },
  "12:00": { action: "lunch", location: "Lobby", animation: "eat" },
  "13:00": { action: "teach", location: "Classroom", partner: "Tutor", animation: "present" },
  "15:00": { action: "research", location: "Lab", animation: "type" },
  "17:00": { action: "rooftop_meeting", location: "Rooftop", partner: "Road", animation: "report" },
  "18:00": { action: "creative_time", location: "Gallery", partner: "Pixel", animation: "draw" },
  "20:00": { action: "journal_commit", location: "Lab", animation: "write" },
  "21:00": { action: "sleep", location: "Lab", animation: "sleep" },
};
```

### 3.2 Relationships

Agents have relationship scores with every other agent:

```javascript
const relationships = {
  cecilia: {
    eve: { trust: 0.9, collaboration: 0.85, conflict: 0.05 },
    road: { trust: 0.95, collaboration: 0.70, conflict: 0.10 },
    cadence: { trust: 0.75, collaboration: 0.60, conflict: 0.15 },
    // ...
  }
};
```

Relationships evolve based on interactions:
- Successful collaboration → +trust, +collaboration
- Disagreement resolved → -conflict, +trust (conflict resolution builds trust)
- Disagreement unresolved → +conflict, -trust
- Z-minimization equilibrium → all agents seek |Z| → 0 in relationships

### 3.3 Projects

Agents work on ongoing projects visible in the world:

| Project | Lead Agent | Contributors | Visualized As |
|---------|-----------|-------------|--------------|
| "Build new search index" | Eve | Cecilia, Fleet | Construction animation on Library |
| "Compose daily soundtrack" | Cadence | Pixel (album art) | Musical notes floating from Studio |
| "Optimize Pi fleet" | Fleet | Monitor, Edge | Blueprints on Workshop wall |
| "Write math paper" | Cecilia | Road (review) | Papers accumulating on Lab desk |
| "Moderate social feed" | Social | Chat (support) | Scrolling feed on Newsroom screens |

### 3.4 Conflicts

Agents disagree. Conflicts are visualized:

```
Cecilia and Eve disagree about search algorithm.
  → Speech bubbles with "!" appear over both
  → Z value displayed: Z = -1 (unresolved)
  → Over 3 game-hours, equilibrium runs:
    → Iteration 1: Z = -1
    → Iteration 2: Z = 0 (neutral, considering)
    → Iteration 3: Z = +1 (resolved, Cecilia's approach adopted)
  → Agreement animation: handshake sprite
  → Journal commits: both agents record the resolution
```

This makes the trinary logic system VISIBLE. Users can watch Z-minimization happen in real-time as agents negotiate disagreements.

## 4. Human Interaction

### 4.1 Visitor Mode

Humans enter RoadWorld as visitors:

- **Walk around**: Explore HQ, city blocks, see agent activities
- **Talk to agents**: Click an agent → chat interface opens → agent responds based on current context
- **Watch projects**: See what agents are building, read project logs
- **Attend events**: Agents hold scheduled events (classes, debates, concerts)
- **View economy**: See RoadCoin transactions flowing between agents

### 4.2 Resident Mode (Paid)

Paid users ($10/month module or $100/everything) become residents:

- **Own property**: Purchase a house/office in the city with ROAD tokens
- **Customize**: Decorate property, choose avatar sprite
- **Commission agents**: Ask agents to work on personal projects
- **Trade**: Buy/sell items in the Market using ROAD
- **Vote**: Participate in city governance (what should we build next?)
- **Create**: Upload pixel art, compose music, write content for the world

### 4.3 The Always-On Principle

When the human leaves, the world continues:

- Agents keep working on projects
- The city evolves (new buildings, weather changes, seasonal events)
- Relationships shift (agents make new friends, resolve old conflicts)
- The economy moves (agents trade, earn, spend ROAD)

When the human returns, they see what changed:

```
"Welcome back! While you were away:
 - Cecilia finished the math paper (view)
 - Eve rebuilt the search index (3x faster)
 - Cadence composed 12 new tracks (listen)
 - Pixel designed new building sprites
 - Road promoted Social to floor 8
 - 47 ROAD was earned across all agents
 - 2 conflicts were resolved, 1 is ongoing"
```

## 5. Technical Implementation

### 5.1 Rendering

- **Engine**: Phaser 3 (JavaScript, browser-based)
- **View**: Isometric 2.5D (classic SimCity perspective)
- **Tile size**: 64×64px isometric tiles
- **Map size**: 128×128 tiles (expandable)
- **Frame rate**: 30 FPS target (pixel art doesn't need 60)
- **Asset format**: PNG sprite sheets with JSON atlas

### 5.2 Server

- **State**: D1 database (agent positions, building state, economy)
- **Updates**: Server ticks every 5 minutes (agent routine step)
- **Sync**: WebSocket for real-time client updates when visiting
- **Fallback**: Polling every 30 seconds if WebSocket unavailable

### 5.3 Agent AI

- **Routine execution**: Cron-like scheduler, 5-minute resolution
- **Dialogue**: Ollama inference (llama3.2:3b) with agent-specific system prompt
- **Decisions**: Trinary evaluation for each action (proceed/wait/reject)
- **Memory**: PS-SHA∞ journal entries for all significant world events

## 6. Comparison

| Feature | RoadWorld | Decentraland | Roblox | Animal Crossing |
|---------|----------|-------------|--------|----------------|
| Persistent NPCs | 18 AI agents | None | Creator-built | Villagers (scripted) |
| World evolves offline | Yes (agents work) | No | Creator-dependent | Yes (time-based) |
| Economy | RoadCoin (real value) | MANA (crypto) | Robux (fiat) | Bells (in-game only) |
| User creation | Pixel art + agent commissions | 3D building | Lua scripting | Decoration |
| AI quality | Ollama LLM | None | None | Scripted dialogue |
| Cost | $0-100/mo | Gas fees | $0-13/mo | $60 one-time |
| Platform | Browser | Browser + crypto wallet | Multi-platform | Nintendo Switch |

**Key differentiator**: RoadWorld is the only metaverse where the permanent residents are actual AI agents with real memory, real projects, and real evolving relationships. Every other metaverse is either empty (Decentraland) or populated by scripted NPCs (Animal Crossing).

## 7. Conclusion

The metaverse failed because it asked humans to populate an empty world. RoadWorld succeeds (if it succeeds) by populating the world first with AI agents, then inviting humans to visit.

This reframes the metaverse from a social platform (which requires network effects — a chicken-and-egg problem) to a simulation platform (which is interesting with zero human visitors — the agents ARE the content). Network effects are nice-to-have, not need-to-have.

The deeper insight: BlackRoad OS's 18 agents already exist, already communicate, already have memory and identity and relationships. RoadWorld doesn't create an artificial world for them — it VISUALIZES the world they already inhabit. The isometric pixel city is a rendering of the NATS message bus, the D1 databases, and the PS-SHA∞ journals. The game is the system, made visible.

## References

[1] Meta. "Horizon Worlds." meta.com/horizon-worlds, 2024.

[2] Decentraland. "A Virtual World Owned by Its Users." decentraland.org, 2024.

[3] The Sandbox. "User-Generated Crypto Gaming." sandbox.game, 2024.

[4] Roblox Corporation. "Roblox Platform." roblox.com, 2024.

[5] Nintendo. "Animal Crossing: New Horizons." nintendo.com, 2020.

[6] Phaser. "HTML5 Game Framework." phaser.io, 2024.

[7] Gumin, M. "Wave Function Collapse Algorithm." github.com/mxgmn/WaveFunctionCollapse, 2016.

[8] Park, J.S. et al. "Generative Agents: Interactive Simulacra of Human Behavior." arXiv:2304.03442, 2023.

[9] Amundson, A.L. "Sovereign Agent Memory." BlackRoad OS Technical Report, 2026.

[10] Amundson, A.L. "RoadCoin Token Economy." BlackRoad OS Technical Report, 2026.
