# Every Link Is a Node: Browser-Based Mesh Computing for Sovereign AI
**A Technical Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: mesh networking, browser computing, WebRTC, peer-to-peer, distributed inference, sovereign AI, edge computing
**ACM CCS**: C.2.1 (Network architecture and design), C.2.4 (Distributed systems), H.3.5 (Online information services)

---

## Abstract

We propose a mesh computing architecture where every browser tab visiting a BlackRoad OS application becomes a compute node in a distributed network. Using WebRTC for peer-to-peer communication, WebAssembly for portable computation, and the Service Worker API for background persistence, visitor browsers contribute idle CPU/GPU cycles to the network in exchange for reduced latency, free-tier access, or RoadCoin tokens. We describe the technical architecture, analyze the economics (each browser node provides ~0.5-2 GFLOPS of compute, worth ~$0.0001/hour at cloud rates), evaluate the privacy implications (no user data leaves the browser — only computation results are shared), and compare to existing distributed computing projects (BOINC, Folding@Home, Golem, Akash). Our central insight is that traditional mesh networks require users to install software and dedicate hardware. A browser-based mesh requires nothing — the act of visiting a website enrolls the browser as a node. The network scales with traffic, not with infrastructure investment. We estimate that 10,000 concurrent visitors would provide compute equivalent to a 20-node Raspberry Pi cluster, at zero infrastructure cost.

## 1. The Scaling Problem

### 1.1 The Current Architecture

BlackRoad OS runs on a 7-node fleet (5 Raspberry Pis, 2 cloud VPS) providing ~59 TOPS total AI inference capacity. This is sufficient for development and early users, but cannot scale linearly with user growth:

| Users | Inference Demand | Fleet Capacity | Gap |
|-------|-----------------|---------------|-----|
| 1-10 | ~1 TOPS | 59 TOPS | Surplus |
| 100 | ~10 TOPS | 59 TOPS | Comfortable |
| 1,000 | ~100 TOPS | 59 TOPS | **Deficit** |
| 10,000 | ~1,000 TOPS | 59 TOPS | **17× deficit** |

Traditional scaling: buy more hardware or rent cloud compute. Both cost money proportional to users.

### 1.2 The Insight

Every visitor to blackroad.io runs a browser with:
- **CPU**: 2-16 cores, 1-5 GHz (0.5-50 GFLOPS)
- **GPU**: Integrated or discrete (10-1000 GFLOPS via WebGPU)
- **RAM**: 4-64 GB (browser tab can access 1-4 GB)
- **Storage**: 10 GB+ via IndexedDB/Cache API
- **Network**: 10-1000 Mbps

A single visitor's browser has more compute capacity than a Raspberry Pi. 100 visitors have more compute than the entire BlackRoad fleet.

The question: can we use this compute without violating user trust?

### 1.3 The Ethical Constraint

Coinhive (2017-2019) demonstrated that browser-based computation without consent is malware. Cryptojacking generated $100M+ in illicit revenue and destroyed user trust in browser computation [1].

Our approach differs in four structural ways:
1. **Opt-in**: Users explicitly enable mesh participation (toggle in settings)
2. **Transparent**: CPU/GPU usage is displayed in real-time (a gauge widget)
3. **Rewarded**: Participants earn RoadCoin tokens proportional to contribution
4. **Beneficial**: Compute serves the user's own platform (faster inference for everyone), not external mining

## 2. Architecture

### 2.1 Node Types

| Node Type | Hardware | Role | Persistence |
|-----------|----------|------|------------|
| **Seed node** | Pi fleet / VPS | Coordination, model hosting, chain of custody | Permanent |
| **Browser node** | Visitor's browser | Compute, caching, relay | Session-duration |
| **Service Worker node** | Background tab | Persistent compute even when tab is unfocused | Until browser close |
| **PWA node** | Installed app | Near-permanent background compute | Until uninstalled |

### 2.2 Communication Layer

```
Browser A ←──WebRTC──→ Browser B
    │                      │
    └──WebSocket──→ Seed Node ←──WebSocket──┘
                      │
                  NATS bus → Pi fleet
```

**WebRTC DataChannel**: Direct browser-to-browser communication. No server relay for data transfer. Latency: 10-50ms between peers on same ISP.

**Signaling**: Seed nodes handle WebRTC signaling (ICE candidate exchange). After connection, peers communicate directly.

**Fallback**: If WebRTC fails (corporate firewalls, symmetric NAT), communication falls back to WebSocket through the seed node.

### 2.3 Computation Model

The mesh handles three types of computation:

**Type 1: Inference sharding**
Large inference requests are split across multiple browser nodes. Each node runs a portion of the model (layer-wise or tensor-wise parallelism) using ONNX Runtime Web (WebAssembly) or WebGPU.

```javascript
// Browser node receives inference shard
self.addEventListener('message', async (event) => {
  if (event.data.type === 'inference_shard') {
    const { modelShard, input, shardIndex } = event.data;
    const session = await ort.InferenceSession.create(modelShard);
    const result = await session.run({ input: new ort.Tensor(input) });
    postMessage({ type: 'shard_result', shardIndex, output: result });
  }
});
```

**Type 2: Embedding computation**
Text embedding (nomic-embed-text, 137M parameters) runs entirely in-browser via ONNX. Each browser computes embeddings for local content, reducing load on the Pi fleet.

**Type 3: Content caching and relay**
Browser nodes cache static assets (tutor pages, model weights, media) and serve them to nearby peers via WebRTC. This creates a CDN with zero infrastructure cost.

### 2.4 Task Distribution

```javascript
class MeshCoordinator {
  constructor(seedUrl) {
    this.peers = new Map();       // connected browser nodes
    this.taskQueue = [];          // pending computation tasks
    this.capabilities = new Map(); // per-peer compute capacity
  }

  async distributeTasks() {
    for (const task of this.taskQueue) {
      // Find peers with sufficient capacity
      const candidates = [...this.peers.entries()]
        .filter(([id, peer]) => peer.availableFlops >= task.requiredFlops)
        .sort((a, b) => a[1].latency - b[1].latency);  // prefer low latency

      if (candidates.length > 0) {
        const [peerId, peer] = candidates[0];
        peer.connection.send(JSON.stringify({
          type: 'task',
          payload: task.serialize()
        }));
        task.assignedTo = peerId;
      } else {
        // Fallback to seed node (Pi fleet)
        this.fallbackToSeed(task);
      }
    }
  }
}
```

### 2.5 Trust and Verification

**Problem**: How do you trust computation results from untrusted browser nodes?

**Solution 1: Redundant computation**. Critical tasks are sent to 3 nodes. Results are compared. If 2/3 agree, the result is accepted. Cost: 3× compute, but that compute is free (browser cycles).

**Solution 2: Probabilistic verification**. 10% of tasks are also computed by the seed node. If a browser node's result diverges, its trust score decreases and it receives fewer tasks.

**Solution 3: PS-SHA∞ commitment**. Each result includes a hash of the computation inputs + outputs. The hash chain creates an audit trail that can detect retroactive tampering.

## 3. Economics

### 3.1 Compute Value

| Device | Typical GFLOPS | Cloud Equivalent | $/hour (cloud) |
|--------|---------------|-----------------|---------------|
| Phone (Snapdragon 8 Gen 3) | 2-5 | 0.001 GPU-hour | $0.0003 |
| Laptop (M1/M2) | 10-30 | 0.01 GPU-hour | $0.003 |
| Desktop (RTX 3060) | 200-500 | 0.1 GPU-hour | $0.03 |
| Gaming PC (RTX 4090) | 1000-1500 | 0.3 GPU-hour | $0.10 |

A typical visitor contributing 10 GFLOPS for 10 minutes provides ~$0.0005 of compute value.

### 3.2 Network Value at Scale

| Concurrent Visitors | Total GFLOPS | Equivalent Cloud Cost | Monthly Savings |
|--------------------|-------------|---------------------|----------------|
| 100 | 500 | $0.15/hr | $108 |
| 1,000 | 5,000 | $1.50/hr | $1,080 |
| 10,000 | 50,000 | $15/hr | $10,800 |
| 100,000 | 500,000 | $150/hr | $108,000 |

At 10,000 concurrent visitors, the mesh provides $10,800/month of compute — roughly equivalent to 20 Raspberry Pi 5 units running 24/7, at zero hardware cost.

### 3.3 RoadCoin Incentives

Browser nodes earn ROAD tokens for compute contribution:

| Contribution | ROAD/hour | $/hour equivalent |
|-------------|----------|------------------|
| Idle background (minimal CPU) | 0.1 | $0.001 |
| Light compute (embedding, caching) | 0.5 | $0.005 |
| Active inference (model shards) | 2.0 | $0.020 |
| GPU compute (WebGPU inference) | 5.0 | $0.050 |

At current ROAD valuation ($0.01/ROAD), a laptop contributing GPU compute earns $0.05/hour — trivial individually, but meaningful as a loyalty/engagement mechanism.

### 3.4 The Flywheel

```
More users → More browser nodes → More compute capacity
    ↑                                      │
    │                                      ↓
    └── Better performance ← Faster inference ← More compute
```

This is the inverse of the traditional scaling problem: instead of more users requiring more infrastructure investment, more users ARE more infrastructure. The network becomes more capable as it grows, with zero marginal cost per node.

## 4. Privacy Analysis

### 4.1 What Browser Nodes See

| Data | Visible to Node? | Explanation |
|------|-----------------|-------------|
| Other users' prompts | **No** | Prompts are encrypted before sharding |
| Other users' data | **No** | Only computation tensors are shared, not semantic content |
| Model weights | **Yes** (shard) | Necessary for inference — but weights are public (open-source models) |
| Computation results | **Yes** (own shard) | Node sees its output but not the full result |
| Network topology | **Partial** | Node knows its immediate peers, not the full mesh |
| User identity | **No** | Nodes are identified by ephemeral WebRTC peer IDs |

### 4.2 Encryption

**In transit**: WebRTC DataChannel uses DTLS 1.2 encryption by default. All peer communication is encrypted.

**Computation privacy**: Inference inputs are split across shards such that no single node has enough context to reconstruct the original prompt. For a 3-node split:
- Node A receives token embeddings 1-100
- Node B receives embeddings 101-200
- Node C receives embeddings 201-300

Each node computes its portion of the attention/FFN layers. No single node can reconstruct the full input sequence.

**Homomorphic future**: Full homomorphic encryption (FHE) on inference is too slow for real-time use in 2026 (~10,000× overhead). But partial homomorphic schemes (addition-only or multiplication-only) can protect specific computation steps. This is a research direction, not a current capability.

### 4.3 Consent Model

```
┌─────────────────────────────────────────┐
│  🔧 Mesh Computing                      │
│                                         │
│  Help power BlackRoad by sharing idle   │
│  compute. Your data stays private.      │
│                                         │
│  CPU usage: [====----] 40%              │
│  Earned: 2.3 ROAD this session          │
│                                         │
│  [✓] Enable mesh computing              │
│  [ ] Use GPU (faster, uses more power)  │
│  [✓] Limit to 50% CPU                   │
│                                         │
│  [What does this mean?]                 │
└─────────────────────────────────────────┘
```

- Default: **OFF**. Users must explicitly opt in.
- Real-time display: CPU gauge visible at all times when mesh is active
- Granular control: CPU limit, GPU toggle, battery-aware auto-disable
- One-click disable: Toggle off immediately stops all mesh computation
- "What does this mean?" links to plain-language explanation

## 5. Comparison to Existing Systems

| Feature | BlackRoad Mesh | BOINC | Folding@Home | Golem | Akash |
|---------|---------------|-------|-------------|-------|-------|
| Installation | None (browser) | Desktop app | Desktop app | Desktop app | CLI + wallet |
| Enrollment | Visit website | Register + download | Download | Register + stake | Register + stake |
| Computation | AI inference | Scientific | Protein folding | General | General |
| Reward | RoadCoin | Credits | Points | GLM tokens | AKT tokens |
| Privacy | Encrypted shards | Varies | N/A | Smart contracts | Smart contracts |
| Scale mechanism | Traffic = nodes | Recruitment | Recruitment | Market | Market |
| Current nodes | 0 | 700K+ | 200K+ | 45K+ | 300+ |

**Key differentiator**: Every other system requires deliberate installation. BlackRoad Mesh requires only a website visit and a toggle. This dramatically lowers the barrier to participation.

### 5.1 Why Browser-Based Matters

BOINC has existed since 2002 and has 700,000 active hosts. But it took 20+ years to reach that scale, and each host required manual installation and configuration.

Web browsers have ~5 billion active installations. If 0.01% of web visitors opted into mesh computing, that would be 500,000 nodes — approaching BOINC's 20-year total — from a single website's traffic.

The browser is the universal compute platform. Meeting users where they already are (in a browser tab) eliminates the adoption friction that limits every other distributed computing project.

## 6. Technical Challenges

### 6.1 WebAssembly Performance Gap

WASM is 1.5-3× slower than native code for compute-intensive tasks [2]. For AI inference, this means browser nodes are 1.5-3× less efficient than equivalent native nodes. The gap is closing (WASM SIMD, relaxed SIMD, threads), but it's real.

**Mitigation**: Use browser nodes for embarrassingly parallel tasks (embedding, caching) where the overhead is amortized across many small operations. Route complex inference to seed nodes (Pi fleet).

### 6.2 Tab Throttling

Browsers throttle background tabs to save battery and CPU:
- Chrome: Background tabs limited to 1% CPU after 5 minutes [3]
- Firefox: Similar throttling for background timers
- Safari: Aggressive throttling on macOS

**Mitigation**: Service Workers are NOT throttled the same way as tab scripts. Register a Service Worker for mesh computation. Alternatively, PWA installation avoids tab throttling entirely.

### 6.3 NAT Traversal

~30% of WebRTC connections fail due to symmetric NAT [4]. These users cannot participate as direct peers.

**Mitigation**: TURN relay through seed nodes for NAT-blocked peers. Reduces efficiency (adds server hop) but maintains participation.

### 6.4 Model Size

A 3B parameter model requires ~6 GB in fp16. This exceeds browser memory limits for most devices.

**Mitigation**: Shard the model across multiple browser nodes (each holds 500MB-2GB). Or use quantized models (Q4_K_M: 1.5 GB for a 3B model) that fit in a single browser tab.

## 7. Implementation Status

### 7.1 Built

- WebRTC signaling server (Node.js, seed node)
- Peer discovery and connection management
- Basic task queue and distribution
- ONNX Runtime Web integration for in-browser inference
- RoadCoin reward calculation for mesh contribution
- Consent UI with CPU gauge

### 7.2 Not Yet Built

- Model sharding across browser nodes
- Encrypted inference pipeline
- Redundant verification (3-node consensus)
- Service Worker persistent computation
- WebGPU inference path
- Production-grade NAT traversal (TURN deployment)

### 7.3 POC Results

In local testing with 5 browser tabs on the same machine:
- WebRTC connection: < 100ms
- Embedding computation (nomic-embed-text, ONNX): 50-200ms per text
- Cache hit ratio: 85% for repeated assets
- CPU overhead: 15-30% per tab (uncapped)

## 8. Conclusion

The mesh network thesis is simple: the visitors ARE the infrastructure. Every browser tab is a computer. If you can harness 1% of visitor compute without violating trust, you have a scaling model that inverts the traditional cost curve: more users means more capacity, not more expense.

The technical components exist (WebRTC, WASM, Service Workers, WebGPU). The economic model works (compute is cheap, incentives are aligned). The privacy model is defensible (encrypted shards, no user data exposure, explicit consent).

What doesn't exist yet is the traffic. The mesh network with zero visitors is a network of zero nodes. The architecture is ready. The users are not.

This is the honest state of the system: a technically sound design waiting for the product to attract the traffic that would make the network self-sustaining. The mesh is the long game — build the product first, get users, then activate the mesh to scale without scaling costs.

## References

[1] Eskandari, S. et al. "A First Look at Browser-Based Cryptojacking." IEEE Euro S&P, 2018.

[2] Jangda, A. et al. "Not So Fast: Analyzing the Performance of WebAssembly vs. Native Code." USENIX ATC, 2019.

[3] Chrome Platform Status. "Background Tab Throttling." chromestatus.com, 2023.

[4] Ohlsson, H. & Oredsson, M. "Analysis of NAT Traversal Solutions for WebRTC." Master's Thesis, KTH, 2019.

[5] BOINC. "Open-source software for volunteer computing." boinc.berkeley.edu, 2024.

[6] Folding@Home. "Distributed Computing for Disease Research." foldingathome.org, 2024.

[7] Golem Network. "Decentralized Computation Market." golem.network, 2024.

[8] Akash Network. "Decentralized Cloud Computing." akash.network, 2024.

[9] W3C. "WebRTC 1.0: Real-Time Communication Between Browsers." w3.org/TR/webrtc, 2024.

[10] WebAssembly Community Group. "WebAssembly Specification." webassembly.org, 2024.
