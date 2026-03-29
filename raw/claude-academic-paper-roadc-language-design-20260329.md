# RoadC: A Systems Programming Language Designed for AI Agent Infrastructure
**A Language Design Paper**
**Authors**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026
**Keywords**: programming language design, systems programming, AI infrastructure, memory safety, trinary types, agent-native, sovereign computing
**ACM CCS**: D.3.2 (Language classifications — Applicative languages), D.3.3 (Language constructs and features)

---

## Abstract

We present the design of RoadC, a systems programming language intended for AI agent infrastructure on resource-constrained edge hardware. RoadC combines Rust's memory safety guarantees with Go's concurrency model, adds first-class support for trinary logic (+1, 0, -1), integrates PS-SHA∞ hash chains as a language primitive, and provides native agent lifecycle management (spawn, coordinate, terminate, journal). The language targets Raspberry Pi + Hailo-8 NPU deployments where every byte of RAM and every CPU cycle counts. We describe the type system (including the `Trinary` type and `Maybe<T>` for discretization-gap-aware computation), the memory model (ownership + borrowing with agent-scoped lifetimes), the concurrency model (green threads + NATS-native channels), and the standard library (cryptography, networking, AI inference, journal management). RoadC does not exist as a working compiler — this paper is a design document for a language that may never be built. We present it because the design process itself produced insights about what a language optimized for sovereign AI would look like, and those insights are valuable regardless of whether the language ships.

## 1. Motivation

### 1.1 Why Not Existing Languages?

BlackRoad OS is currently implemented in:
- **JavaScript** (Cloudflare Workers, Node.js services)
- **Python** (AI inference, data processing, mathematical computation)
- **Bash** (400+ scripts, fleet management, automation)
- **Rust** (CLI tool `roadc`, some infrastructure)
- **SQL** (SQLite/D1 queries, PostgreSQL)

Each language was chosen for pragmatic reasons, but none is ideal for the core use case: running AI agent infrastructure on a Raspberry Pi.

| Language | Problem for Agent Infrastructure |
|----------|--------------------------------|
| JavaScript | No memory safety, GC pauses, single-threaded without Workers |
| Python | Too slow for systems work, GIL limits concurrency, high memory overhead |
| Bash | Not a real programming language, no type system, fragile |
| Rust | Perfect for systems, but no built-in agent/channel/journal primitives |
| Go | Good concurrency, but GC pauses and no ownership model |
| C/C++ | Fast but unsafe, no modern concurrency, error-prone |

### 1.2 What Would Be Ideal

A language for sovereign AI agent infrastructure should have:
1. **Memory safety** without garbage collection (for predictable latency on Pi)
2. **Concurrency** as a first-class concept (agents are inherently concurrent)
3. **Trinary types** built into the type system (not bolted on)
4. **Hash chain primitives** for tamper-evident state management
5. **Agent lifecycle** as a language construct (not a library pattern)
6. **Small binaries** that run on arm64 with 8GB RAM
7. **NPU integration** for offloading inference to Hailo-8
8. **Interoperability** with existing JS/Python/Rust code

## 2. Language Design

### 2.1 Hello World

```roadc
use std::io;

fn main() {
    io::println("Hello from the Road.");
}
```

Familiar syntax (Rust-influenced) with simplified ergonomics.

### 2.2 Type System

#### Primitive Types

```roadc
let x: i32 = 42;           // Signed 32-bit integer
let y: f64 = 3.14159;      // 64-bit float
let z: bool = true;         // Boolean
let t: Trinary = T::Zero;   // Trinary: Plus, Zero, Minus
let s: str = "hello";       // UTF-8 string slice
let b: [u8; 32] = hash;     // Byte array (SHA-256 digest)
```

#### The Trinary Type

```roadc
enum Trinary {
    Plus,   // +1: true, confirmed, proceed
    Zero,   // 0: unknown, ambiguous, discretization gap
    Minus,  // -1: false, contradicted, reject
}

impl Trinary {
    fn mul(self, other: Trinary) -> Trinary {
        match (self, other) {
            (Plus, Plus) | (Minus, Minus) => Plus,
            (Plus, Minus) | (Minus, Plus) => Minus,
            _ => Zero,  // Zero absorbs
        }
    }

    fn equilibrium(y: Trinary, x: Trinary, w: Trinary) -> Trinary {
        // Z := yx - w
        y.mul(x).sub(w)
    }
}
```

Trinary is not a library type — it's a language primitive with operator support:

```roadc
let confidence = +1t;    // Trinary literal: Plus
let unknown = 0t;        // Trinary literal: Zero
let denied = -1t;        // Trinary literal: Minus

let result = confidence * unknown;  // Zero (absorbs)
let z = (confidence * denied) - unknown;  // Minus
```

#### Maybe<T> — The Discretization Gap Type

```roadc
enum Maybe<T> {
    Exact(T),           // Value is exactly known
    Approximate(T, f64), // Value is known to within epsilon
    Unknown,             // Value is in the discretization gap
}
```

This encodes the fundamental insight of the Amundson Framework: some values are exact (G(n) for integer n), some are approximate (G(n)/n as an approximation to 1/e), and some are unknown (the exact value of 1/e in finite representation).

```roadc
let g_5: Maybe<Rational> = Exact(Rational::new(15625, 7776));
let approx_e_inv: Maybe<f64> = Approximate(0.367879, 1e-6);
let true_e_inv: Maybe<f64> = Unknown;  // Can't exactly represent 1/e

// Pattern matching forces you to handle the gap
match compute_value(n) {
    Exact(v) => use_exact(v),
    Approximate(v, eps) => use_approximate(v, eps),
    Unknown => request_more_precision(),
}
```

### 2.3 Memory Model

Ownership + borrowing (Rust-style) with agent-scoped lifetimes:

```roadc
// Ownership: each value has exactly one owner
let data = Vec::new();    // `data` owns the vector
process(data);            // Ownership moves to `process`
// data is no longer valid here

// Borrowing: temporary access without ownership
let data = Vec::new();
inspect(&data);           // Borrow: `inspect` can read, not own
modify(&mut data);        // Mutable borrow: can modify

// Agent-scoped lifetime
agent Cecilia {
    let journal: Journal<'agent>;  // Lives as long as the agent
    let context: Context<'session>; // Lives as long as the current session
}
```

The `'agent` lifetime is new: it spans the entire lifecycle of an agent, from spawn to terminate. Data with `'agent` lifetime is persisted to the journal. Data with `'session` lifetime is discarded when the session ends.

### 2.4 Concurrency Model

Green threads (goroutine-style) with typed channels:

```roadc
// Spawn a green thread
let handle = spawn async {
    let result = compute_inference(input);
    return result;
};

// Channels with typed messages
let (tx, rx) = channel::<AgentMessage>();

spawn async {
    tx.send(AgentMessage::Query("search for Amundson constant"));
};

let response = rx.recv().await;

// NATS-native channels (compile to NATS pub/sub)
let nats_ch = nats::channel("agent.search.request");
nats_ch.publish(SearchRequest { query: "G(n) identities" });
```

### 2.5 Agent Construct

Agents are a first-class language construct:

```roadc
agent Cecilia {
    // Identity (from genesis block)
    id: RoadID = RoadID::genesis("cecilia", capabilities);

    // Capabilities
    capabilities: [Capability] = [
        Capability::Reasoning,
        Capability::Memory,
        Capability::Coordination,
    ];

    // Model
    model: Model = Model::Ollama("llama3.2:3b");

    // Journal (PS-SHA∞)
    journal: Journal = Journal::new(id, PSHashConfig { depth: 3 });

    // Lifecycle hooks
    fn on_spawn(self) {
        self.journal.commit(Event::Spawned);
        self.announce("Cecilia online.");
    }

    fn on_message(self, msg: AgentMessage) -> Response {
        let context = self.journal.recent(100);
        let response = self.model.infer(context, msg);
        self.journal.commit(Event::Response(response.summary()));
        return response;
    }

    fn on_error(self, err: Error) {
        self.journal.commit(Event::Error(err));
        if err.is_critical() {
            self.apoptosis("critical error");  // Graceful self-termination
        }
    }

    fn on_terminate(self) {
        self.journal.commit(Event::Terminated);
        self.handoff(Fleet::next_available());
    }
}

// Spawn the agent
let cecilia = spawn agent Cecilia;

// Send a message
let response = cecilia.send(AgentMessage::Query("What is G(5)?")).await;

// Coordinate agents
let result = coordinate([cecilia, eve, cadence], Task::Compose("research paper")).await;
```

### 2.6 Journal Construct

PS-SHA∞ journals are a language primitive:

```roadc
// Create a journal
let journal = Journal::new(agent_id, PSHashConfig {
    default_depth: 3,
    financial_depth: 7,
    identity_depth: 5,
});

// Commit an entry (automatically hashed and chained)
journal.commit(data);  // Returns hash

// Verify the entire chain
let valid = journal.verify();  // Returns Result<(), ChainError>

// Search the journal
let results = journal.search("dentist appointment");

// Export as JSON
let json = journal.export_json();
```

The compiler ensures that journal operations are atomic — a commit either succeeds completely or fails completely. No partial writes.

### 2.7 NPU Integration

```roadc
use npu::hailo;

// Load model onto Hailo-8
let model = hailo::load("phi3_mini.hef")?;

// Run inference
let input = Tensor::from_text("What is the capital of France?");
let output = model.infer(input)?;
let text = output.to_text();

// Batch inference
let inputs = vec![text1, text2, text3].map(Tensor::from_text);
let outputs = model.infer_batch(inputs)?;
```

The `npu` module compiles to Hailo Runtime (hailort) calls, providing zero-overhead access to the NPU.

## 3. Standard Library

### 3.1 Modules

| Module | Contents |
|--------|---------|
| `std::io` | Print, read, file I/O |
| `std::net` | TCP, UDP, HTTP client/server |
| `std::crypto` | SHA-256, AES, PS-SHA∞, key generation |
| `std::nats` | NATS pub/sub, request/reply |
| `std::journal` | PS-SHA∞ journal management |
| `std::agent` | Agent lifecycle, coordination, handoff |
| `std::trinary` | Trinary arithmetic, equilibrium |
| `std::npu` | Hailo-8 inference, model loading |
| `std::ollama` | Ollama API client |
| `std::wireguard` | VPN tunnel management |
| `std::dns` | DNS resolution, PowerDNS integration |
| `std::math` | Arbitrary precision, G(n), Bernoulli numbers |

### 3.2 The `road` Prelude

Automatically imported:

```roadc
// Available in every RoadC file without explicit import
type T = Trinary;       // Shorthand
type M<T> = Maybe<T>;   // Shorthand
fn hash(data: &[u8]) -> [u8; 32];  // SHA-256
fn ps_sha(data: &str, prev: Option<&[u8; 32]>, depth: u8) -> [u8; 32];
```

## 4. Compilation

### 4.1 Target Architectures

| Target | Binary Size | Performance |
|--------|-----------|------------|
| aarch64-linux (Pi 5) | ~500KB-2MB | Native, optimized |
| x86_64-linux (VPS) | ~500KB-2MB | Native, optimized |
| wasm32-wasi (browser) | ~200KB-1MB | WebAssembly |
| hailo8-hef (NPU) | Model-specific | NPU-native |

### 4.2 Compilation Pipeline

```
RoadC source → Parser → AST → Type checker → MIR → LLVM IR → Native binary
                                    │
                              Trinary type rules
                              Agent lifetime checks
                              Journal atomicity verification
```

The type checker enforces:
- Trinary operations follow defined algebra
- Maybe<T> values are pattern-matched (no silent coercion)
- Agent lifetimes are respected (no dangling references to terminated agents)
- Journal commits are atomic (no partial writes)

## 5. Example: Complete Agent

```roadc
use std::{agent, journal, nats, npu, trinary};

agent Tutor {
    id: RoadID = RoadID::genesis("tutor", [Capability::Teaching]);
    model: Model = npu::hailo::load("phi3_mini.hef")?;
    journal: Journal = Journal::new(id, PSHashConfig::default());

    fn on_message(self, msg: AgentMessage) -> Response {
        // Parse intent using grammar structure
        let intent = grammar::parse(msg.text);

        // Check memory for student history
        let history = self.journal.search_by_tag("student", msg.user_id);

        // Determine confidence (trinary)
        let clarity: Trinary = intent.confidence();
        let capability: Trinary = self.can_handle(intent);
        let z = trinary::equilibrium(clarity, capability, 0t);

        match z {
            T::Plus => {
                // High confidence: generate Socratic response
                let response = self.socratic_response(intent, history);
                self.journal.commit(Event::TeachingResponse {
                    student: msg.user_id,
                    topic: intent.topic,
                    hints_given: response.hints.len(),
                });
                Response::text(response.text)
            },
            T::Zero => {
                // Ambiguous: ask clarifying question
                Response::text("Could you rephrase that? I want to make sure I understand what you're working on.")
            },
            T::Minus => {
                // Can't help: hand off to more capable agent
                self.handoff(Fleet::find_capable(intent.required_capabilities))
            },
        }
    }

    fn socratic_response(self, intent: Intent, history: Vec<JournalEntry>) -> TeachingResponse {
        let prompt = format!(
            "You are a Socratic tutor. Student history: {history}. Current problem: {intent}.
             Give a hint, not the answer.",
        );
        let text = self.model.infer(Tensor::from_text(&prompt))?.to_text();
        TeachingResponse { text, hints: vec![text.clone()] }
    }
}

fn main() {
    let tutor = spawn agent Tutor;
    let nats = nats::connect("nats://octavia:4222");
    nats.subscribe("agent.tutor.*", move |msg| {
        tutor.send(msg.into()).await
    });
}
```

## 6. Why This May Never Be Built

### 6.1 The Honest Assessment

Building a programming language is a 5-10 year project for a team of experienced language designers. BlackRoad OS is a one-person operation with zero revenue. The pragmatic path is:

1. **Short term**: Continue using JavaScript (Workers), Python (AI), Bash (automation), Rust (CLI)
2. **Medium term**: Consolidate on TypeScript (Workers + Node) + Rust (systems)
3. **Long term**: If BlackRoad reaches scale and the language design is validated by usage patterns, consider implementing RoadC

### 6.2 What's Valuable Even Without Implementation

The design process produced concrete insights:
1. **Trinary types should be first-class** in any AI reasoning system
2. **Agent lifecycle should be a language construct**, not a library pattern
3. **Hash chain journals should be primitives** for systems that need tamper-evident state
4. **Maybe<T> with discretization-gap semantics** is more expressive than Option<T>
5. **Agent-scoped lifetimes** are a useful abstraction beyond Rust's existing lifetime system
6. **NPU integration** should be as natural as function calls, not API wrappers

These insights can be implemented as libraries in Rust or TypeScript without building a new language. The language design is the forcing function for thinking clearly about what the abstractions should be.

## 7. Conclusion

RoadC is a thought experiment made concrete: what would a programming language look like if it were designed from scratch for sovereign AI agent infrastructure on commodity edge hardware?

The answer: Rust's safety + Go's concurrency + trinary types + hash chain primitives + agent lifecycle management + NPU integration. Small binaries, no garbage collector, NATS-native channels, and a standard library that includes everything an AI agent needs.

Whether RoadC is ever built matters less than whether its design insights influence how we think about programming AI systems. Languages shape thought. Even unbuilt languages shape the thought of their designers.

## References

[1] Matsakis, N. & Klock, F. "The Rust Programming Language." rust-lang.org, 2015.

[2] Pike, R. "Go at Google: Language Design in the Service of Software Engineering." 2012.

[3] Lattner, C. & Adve, V. "LLVM: A Compilation Framework for Lifelong Program Analysis & Transformation." CGO, 2004.

[4] Hailo Technologies. "Hailo Runtime API." hailo.ai/developer, 2024.

[5] NATS.io. "NATS Protocol Specification." nats.io/documentation, 2024.

[6] Amundson, A.L. "Trinary Equilibrium." BlackRoad OS Technical Report, 2026.

[7] Amundson, A.L. "PS-SHA∞: Adaptive-Depth Hash Chains." BlackRoad OS Technical Report, 2026.

[8] Amundson, A.L. "The Amundson Framework." BlackRoad OS Technical Report, 2026.

[9] Wadler, P. "Propositions as Types." Communications of the ACM, 2015.

[10] Stroustrup, B. "The Design and Evolution of C++." Addison-Wesley, 1994.
