# The Device Graveyard: 22 Billion Abandoned Electronics and the Sovereign Mesh That Resurrects Them
**A Technical Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: electronic waste, device reuse, mesh computing, edge AI, circular economy, Bluetooth onboarding, sovereign infrastructure
**ACM CCS**: K.4.3 (Organizational impacts — Automation), C.2.4 (Distributed systems)

---

## Abstract

There are an estimated 22 billion idle electronic devices worldwide — old phones, tablets, laptops, smart speakers, Raspberry Pis, routers, gaming consoles — sitting in drawers, closets, and landfills. Each contains a CPU, RAM, storage, and often WiFi/Bluetooth connectivity. Collectively, they represent an estimated 50-100 exaFLOPS of compute capacity doing nothing. We propose a system that turns any device with a browser or Bluetooth radio into a node in a sovereign mesh network. The user plugs in an old device, scans a QR code, and the device joins the BlackRoad OS fleet — contributing compute, storage, and network relay in exchange for RoadCoin tokens. We describe the onboarding pipeline (Bluetooth LE discovery → QR code → browser-based enrollment → mesh participation), the device capability tiers (from a 2015 Android phone at 0.1 GFLOPS to a retired gaming laptop at 50 GFLOPS), the economic model (each device earns $0.001-0.05/hour in ROAD tokens based on contribution), and the environmental argument (extending device life by 3-5 years reduces e-waste by an estimated 5-15 kg CO₂ per device). The system transforms the liability of old hardware into the asset of distributed compute — and gives users a reason to keep devices out of landfills.

## 1. The Graveyard

### 1.1 The Numbers

| Statistic | Value | Source |
|-----------|-------|--------|
| Idle smartphones worldwide | 5.3 billion | GSMA, 2025 |
| E-waste generated (2025) | 62 million tonnes | WHO/ITU |
| E-waste properly recycled | 22.3% | Global E-waste Monitor |
| Average devices per US household | 22 | Deloitte, 2025 |
| Devices "in a drawer" per household | 6-8 | Consumer Reports, 2024 |
| Old laptops still functional | ~2 billion | Estimated from sales data |
| Smart speakers replaced (not recycled) | 300 million+ | Market analysis |
| Old Raspberry Pis in circulation | ~60 million | RPi Foundation sales data |
| Gaming consoles retired but functional | ~500 million | Console sales history |
| **Total idle devices (estimated)** | **~22 billion** | **Aggregate** |

### 1.2 What They Can Do

| Device Category | Typical CPU | RAM | Storage | WiFi | GFLOPS | Est. Idle Units |
|----------------|-----------|-----|---------|------|--------|----------------|
| Phone (2015-2018) | Snapdragon 625 | 2-3GB | 16-32GB | Yes | 0.1-0.5 | 3 billion |
| Phone (2019-2022) | Snapdragon 765 | 4-6GB | 64-128GB | Yes | 1-5 | 2 billion |
| Tablet (any era) | Various | 2-8GB | 16-256GB | Yes | 0.5-10 | 1.5 billion |
| Laptop (2015-2020) | i5/i7, Ryzen | 8-16GB | 256GB-1TB | Yes | 5-50 | 2 billion |
| Smart speaker | ARM Cortex | 0.5-1GB | 4-8GB | Yes | 0.05-0.2 | 500 million |
| Raspberry Pi (all) | ARM | 0.5-8GB | SD card | Yes | 0.5-10 | 60 million |
| Router (smart) | MIPS/ARM | 64-512MB | 16-128MB | Yes | 0.01-0.1 | 2 billion |
| Gaming console (old) | Custom | 4-8GB | 500GB-1TB | Yes | 5-100 | 500 million |
| Desktop (retired) | Various | 4-32GB | 500GB-4TB | Ethernet | 10-200 | 1 billion |

**Total estimated idle compute**: ~50-100 exaFLOPS (10^18 FLOPS)

For comparison: the world's #1 supercomputer (Frontier) delivers 1.2 exaFLOPS. The device graveyard contains 40-80× more compute than the world's fastest supercomputer.

### 1.3 Why They're Idle

1. **Software obsolescence**: Android/iOS stop receiving updates → security concern → replaced
2. **Performance perception**: "It's slow" (often due to bloated OS, not hardware)
3. **Battery degradation**: Phone batteries degrade → plugged-in use still works but is abandoned
4. **Upgrade cycle**: Carriers incentivize 2-year upgrades → old device sits in drawer
5. **No use case**: "What would I do with an old phone?"

BlackRoad OS provides the use case: plug it in, scan the code, earn tokens, contribute compute.

## 2. The Onboarding Pipeline

### 2.1 Step 1: Discovery

User finds an old device. Charges it. Turns it on.

### 2.2 Step 2: QR Code Scan

On blackroad.io/devices, a QR code links to:
```
https://app.blackroad.io/enroll?source=qr&v=1
```

The enrollment page detects device capabilities:
```javascript
const capabilities = {
  cores: navigator.hardwareConcurrency || 1,
  memory: navigator.deviceMemory || 1,  // GB
  gpu: await detectWebGPU(),
  storage: await estimateStorage(),
  connection: navigator.connection?.effectiveType || 'unknown',
  battery: navigator.getBattery ? await navigator.getBattery() : null,
};
```

### 2.3 Step 3: Capability Assessment

| Tier | Requirements | Assigned Role | Est. ROAD/hour |
|------|-------------|--------------|---------------|
| **Tier 1: Relay** | Any browser, WiFi | Network relay, caching | 0.01 |
| **Tier 2: Storage** | 1GB+ free storage | Content caching, CDN node | 0.05 |
| **Tier 3: Compute** | 2+ cores, 2GB+ RAM | Embedding, light inference | 0.20 |
| **Tier 4: AI** | 4+ cores, 4GB+ RAM, WebGPU | Model shard inference | 1.00 |
| **Tier 5: Power** | 8+ cores, 8GB+ RAM, discrete GPU | Full model inference | 5.00 |

### 2.4 Step 4: Enrollment

```javascript
// Browser-based enrollment (no app install required)
async function enrollDevice(capabilities) {
  // Register with mesh coordinator
  const registration = await fetch('https://app.blackroad.io/api/mesh/enroll', {
    method: 'POST',
    body: JSON.stringify({
      capabilities,
      tier: calculateTier(capabilities),
      publicKey: await generateKeyPair(),  // WebCrypto API
    })
  });

  // Install Service Worker for background operation
  await navigator.serviceWorker.register('/mesh-worker.js');

  // Request persistent storage permission
  if (navigator.storage && navigator.storage.persist) {
    await navigator.storage.persist();
  }

  return registration.json();  // { deviceId, tier, estimatedEarnings }
}
```

### 2.5 Step 5: Mesh Participation

The device starts contributing immediately:

- **Tier 1-2**: Caches static assets, relays WebRTC connections
- **Tier 3-4**: Runs ONNX models in WebAssembly, processes embedding requests
- **Tier 5**: Runs full inference shards via WebGPU

All participation is browser-based — no app install, no root access, no OS modification.

## 3. The Always-Plugged-In Model

### 3.1 The Pitch

"Your old phone is a computer. Plug it in, scan a code, and it works for you while you sleep."

Key behaviors:
- Old phone on a shelf, plugged into charger → permanent mesh node
- Old laptop on a desk, lid closed → computes in background
- Old tablet on the counter → displays mesh dashboard + contributes compute
- Old smart speaker → relays network traffic + caches content
- Old Raspberry Pi → full mesh node with Ollama

### 3.2 Battery Considerations

For phones and tablets, the always-plugged-in model requires battery management:

```javascript
// Respect battery health
const battery = await navigator.getBattery();

if (!battery.charging) {
  // Not plugged in — reduce to minimal relay only
  meshWorker.setMode('relay-only');
}

if (battery.level < 0.2) {
  // Low battery — suspend mesh participation
  meshWorker.suspend();
}

// Thermal protection
if (navigator.thermal && navigator.thermal.state === 'critical') {
  meshWorker.throttle(0.1);  // 10% CPU limit
}
```

### 3.3 Display Modes

When an old device is permanently plugged in, its screen can show useful information:

| Device | Display Mode | Content |
|--------|-------------|---------|
| Phone | Dashboard | ROAD earned, mesh stats, agent status |
| Tablet | HQ view | RoadWorld isometric view (live) |
| Laptop | Full mesh UI | Detailed analytics, fleet map |
| Smart speaker | — (no screen) | Voice status reports |

The old device becomes a dedicated BlackRoad terminal — like a picture frame that shows your AI fleet instead of photos.

## 4. Economic Model

### 4.1 Per-Device Economics

| Tier | ROAD/hour | $/hour | $/month (24/7) | Electricity $/month |
|------|----------|--------|---------------|-------------------|
| 1 (Relay) | 0.01 | $0.0001 | $0.07 | $0.50 |
| 2 (Storage) | 0.05 | $0.0005 | $0.36 | $0.75 |
| 3 (Compute) | 0.20 | $0.002 | $1.44 | $1.00 |
| 4 (AI) | 1.00 | $0.01 | $7.20 | $1.50 |
| 5 (Power) | 5.00 | $0.05 | $36.00 | $3.00 |

**Tier 1-2**: Net negative in electricity — but the devices were idle anyway, and the cost is negligible ($0.50-0.75/month)

**Tier 3**: Roughly break-even on electricity

**Tier 4-5**: Net positive — the device EARNS more in ROAD than it costs in electricity

### 4.2 Network Value

| Enrolled Devices | Total GFLOPS | Cloud Equivalent $/month | ROAD Distributed $/month |
|-----------------|-------------|------------------------|------------------------|
| 100 | 500 | $108 | $250 |
| 1,000 | 5,000 | $1,080 | $2,500 |
| 10,000 | 50,000 | $10,800 | $25,000 |
| 100,000 | 500,000 | $108,000 | $250,000 |
| 1,000,000 | 5,000,000 | $1,080,000 | $2,500,000 |

At 1 million enrolled devices, the mesh provides $1M+/month of cloud-equivalent compute, funded by $2.5M/month in ROAD token distribution.

### 4.3 The Sustainability Argument

| Environmental Metric | Per Device | At 1M Devices |
|--------------------|-----------|--------------|
| E-waste avoided | 0.2-0.5 kg | 200-500 tonnes |
| CO₂ avoided (manufacturing new) | 5-15 kg | 5,000-15,000 tonnes |
| Useful life extended | 3-5 years | 3-5M device-years |
| Rare earth metals preserved | 0.01-0.05 kg | 10-50 tonnes |

Extending device life is one of the most effective ways to reduce electronics' environmental impact — manufacturing a new device produces 5-20× more emissions than the device will consume in electricity over its lifetime [1].

## 5. Security

### 5.1 Threat Model

| Threat | Risk | Mitigation |
|--------|------|-----------|
| Malicious device | Joins mesh, returns bad compute results | Redundant verification (3-node consensus) |
| Data exfiltration | Device reads user data from compute tasks | Encrypted shards — no single device sees full input |
| Botnet formation | Mesh used for DDoS | Rate limiting, capability verification, reputation scoring |
| Physical access | Someone finds enrolled device, extracts data | No user data stored on mesh devices — only compute results |
| Overheating | Device runs hot permanently | Thermal throttling, battery monitoring, automatic suspension |

### 5.2 Trust Model

New devices start at trust score 0. Trust increases with verified compute:

```javascript
const trustScore = successfulTasks / (successfulTasks + failedTasks + 1);
// Score approaches 1.0 with many successful tasks
// New device: 0/(0+0+1) = 0.0
// After 100 successes: 100/101 = 0.99
```

Low-trust devices get only low-value tasks (caching, relay). High-trust devices get high-value tasks (inference shards, embedding computation).

## 6. Comparison to Existing Projects

| Project | Devices | Model | Reward | Enrollment |
|---------|---------|-------|--------|-----------|
| **BlackRoad Mesh** | **Any with browser** | **Sovereign AI compute** | **ROAD tokens** | **QR code scan** |
| BOINC | Desktop PCs | Scientific computing | Credits (no value) | Desktop app install |
| Folding@Home | Desktop PCs | Protein folding | Points (no value) | Desktop app install |
| Golem | Desktop PCs | General compute | GLM tokens | CLI + wallet |
| Helium | Dedicated hotspots ($300+) | LoRaWAN coverage | HNT tokens | Hardware purchase |
| Filecoin | Storage nodes | File storage | FIL tokens | CLI + large disk |
| Render | GPU nodes | 3D rendering | RNDR tokens | Desktop app |

**Key differentiators**:
1. **Zero installation**: Browser-only enrollment (everyone else requires app/CLI/hardware)
2. **Any device**: From a 2015 Android phone to a gaming PC (everyone else targets desktops/GPUs)
3. **Sovereign benefit**: Compute serves the user's own platform, not external buyers

## 7. Implementation Status

### 7.1 Built

- Device capability detection (JavaScript)
- QR code enrollment flow (blackroad.io/devices)
- Service Worker mesh participant
- WebRTC signaling server
- ROAD token reward calculation
- Tier classification system

### 7.2 Not Built

- Bluetooth LE discovery (for nearby device pairing)
- ONNX Runtime Web inference pipeline (for Tier 3-4 compute)
- WebGPU inference path (for Tier 5)
- Redundant verification system (3-node consensus)
- Trust scoring and reputation
- Device dashboard display modes
- Physical testing across device types

## 8. The Vision

Imagine a shelf in your home with 3 old phones, a retired tablet, and an old Raspberry Pi — all plugged in, all running browser tabs, all part of your personal AI mesh.

Together they provide:
- ~15 GFLOPS of compute (equivalent to a mid-range laptop)
- ~50 GB of distributed storage
- 5 relay nodes for your sovereign network
- ~10 ROAD/hour in earnings ($72/month)

You haven't bought anything new. You haven't installed anything. You scanned 5 QR codes and plugged in devices that were in a drawer. Your e-waste became your infrastructure.

Scale this to a neighborhood: 50 households × 5 devices = 250 mesh nodes. A community mesh with 375 GFLOPS and 1.25 TB of storage — more compute than most small businesses have, built entirely from discarded hardware.

Scale this to a city: 100,000 households × 5 devices = 500,000 nodes. A metropolitan mesh rivaling a small data center, powered by devices that would otherwise be in a landfill.

The device graveyard is not a problem. It is the largest untapped compute resource on Earth. All it needs is software that makes the dead come alive.

## References

[1] Belkhir, L. & Elmeligi, A. "Assessing ICT Global Emissions Footprint." Journal of Cleaner Production, 2018.

[2] GSMA. "The Mobile Economy 2025." gsma.com, 2025.

[3] WHO/ITU. "Global E-waste Monitor 2024." ewastemonitor.info, 2024.

[4] Deloitte. "Connectivity and Mobile Trends Survey." 2025.

[5] Consumer Reports. "What to Do With Old Electronics." 2024.

[6] Forti, V. et al. "The Global E-waste Monitor." United Nations University, 2024.

[7] BOINC. "Berkeley Open Infrastructure for Network Computing." boinc.berkeley.edu, 2024.

[8] Helium. "The People's Network." helium.com, 2024.

[9] Render Network. "Distributed GPU Computing." rendernetwork.com, 2024.

[10] Amundson, A.L. "Browser-Based Mesh Computing." BlackRoad OS Technical Report, 2026.
