#!/usr/bin/env node

const http = require('http')
const { URL } = require('url')

const PORT = parseInt(process.env.PORT || '8088', 10)

const routes = {
  '/roundtrip': 'http://127.0.0.1:8094',
  '/roadcode': 'http://127.0.0.1:8787',
  '/explorer': 'http://127.0.0.1:8786',
  '/registry': 'http://127.0.0.1:3101',
  '/search-api': 'http://127.0.0.1:3102',
  '/audit-api': 'http://127.0.0.1:3103',
  '/worker': 'http://127.0.0.1:8788',
  '/site': 'http://127.0.0.1:8789',
}

const hostRoutes = {
  'roundtrip.localhost': 'http://127.0.0.1:8094',
  'roadcode.localhost': 'http://127.0.0.1:8787',
  'explorer.localhost': 'http://127.0.0.1:8786',
  'worker.localhost': 'http://127.0.0.1:8788',
  'site.localhost': 'http://127.0.0.1:8789',
  'registry.localhost': 'http://127.0.0.1:3101',
  'search.localhost': 'http://127.0.0.1:3102',
  'audit.localhost': 'http://127.0.0.1:3103',
}

async function probeUpstream(url) {
  const start = Date.now()
  try {
    const target = new URL(url)
    const path = target.pathname === '/' ? '/' : target.pathname
    const result = await new Promise((resolve, reject) => {
      const req = http.request({
        hostname: target.hostname,
        port: target.port,
        path,
        method: 'GET',
        timeout: 1500,
      }, res => {
        res.resume()
        res.on('end', () => {
          resolve({
            ok: (res.statusCode || 500) < 500,
            status: res.statusCode || 500,
          })
        })
      })

      req.on('timeout', () => req.destroy(new Error('timeout')))
      req.on('error', reject)
      req.end()
    })

    return {
      url,
      ok: result.ok,
      status: result.status,
      latencyMs: Date.now() - start,
    }
  } catch (error) {
    return {
      url,
      ok: false,
      status: 502,
      latencyMs: Date.now() - start,
      error: error.message,
    }
  }
}

async function collectUpstreamStatus() {
  const checks = {
    roundtrip: 'http://127.0.0.1:8094',
    roadcode: 'http://127.0.0.1:8787',
    explorer: 'http://127.0.0.1:8786',
    worker: 'http://127.0.0.1:8788',
    site: 'http://127.0.0.1:8789',
    registry: 'http://127.0.0.1:3101/road/v1/health',
    search: 'http://127.0.0.1:3102/road/v1/health',
    audit: 'http://127.0.0.1:3103/road/v1/health',
  }

  const entries = await Promise.all(
    Object.entries(checks).map(async ([name, url]) => [name, await probeUpstream(url)])
  )

  return Object.fromEntries(entries)
}

function indexHtml() {
  const cards = [
    ['RoundTrip chat', 'http://roundtrip.localhost:8088', 'Live multi-agent chat UI'],
    ['RoadCode Prism', 'http://roadcode.localhost:8088', 'Operator dashboard for orgs, repos, nodes, and domains'],
    ['RoadCode Explorer', 'http://explorer.localhost:8088', 'Readable browser for the RoadCode registry'],
    ['RoadCode worker site', 'http://worker.localhost:8088', 'Worker-hosted landing page'],
    ['RoadCode static site', 'http://site.localhost:8088', 'Static landing page copy'],
    ['Registry API', 'http://registry.localhost:8088/road/v1/health', 'Registry service health'],
    ['Search API', 'http://search.localhost:8088/road/v1/health', 'Search service health'],
    ['Audit API', 'http://audit.localhost:8088/road/v1/health', 'Audit service health'],
  ]

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Road Websites</title>
  <style>
    *{box-sizing:border-box}body{margin:0;font-family:ui-sans-serif,system-ui,sans-serif;background:#0a0a0a;color:#f3f3f3}
    main{max-width:1100px;margin:0 auto;padding:48px 20px}
    h1{font-size:48px;margin:0 0 8px}.sub{color:#9a9a9a;margin:0 0 28px}
    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:16px}
    a.card{display:block;padding:18px;border-radius:16px;background:linear-gradient(180deg,#121212,#0f0f0f);border:1px solid #202020;color:inherit;text-decoration:none}
    a.card:hover{border-color:#ff1d6c;transform:translateY(-1px)}
    .name{font-size:20px;margin-bottom:6px}.meta{color:#9a9a9a;font-size:14px}
    code{background:#181818;padding:2px 6px;border-radius:6px}
  </style>
</head>
<body>
  <main>
    <h1>Road Websites</h1>
    <p class="sub">Single local entrypoint for the RoundTrip and RoadCode stack on <code>*.localhost:${PORT}</code>.</p>
    <div class="grid">
      ${cards.map(([name, href, meta]) => `<a class="card" href="${href}"><div class="name">${name}</div><div class="meta">${meta}</div></a>`).join('')}
    </div>
  </main>
</body>
</html>`
}

function proxyRequest(req, res, baseUrl, stripPrefix = null) {
  const target = new URL(baseUrl)
  const path = stripPrefix
    ? (req.url.replace(stripPrefix, '') || '/')
    : (req.url || '/')
  const upstreamUrl = new URL(path, `${target.origin}/`)

  const upstreamReq = http.request(upstreamUrl, {
    method: req.method,
    headers: {
      ...req.headers,
      host: target.host,
    },
  }, upstreamRes => {
    res.writeHead(upstreamRes.statusCode || 502, upstreamRes.headers)
    upstreamRes.pipe(res)
  })

  upstreamReq.on('error', error => {
    res.writeHead(502, { 'content-type': 'text/plain; charset=utf-8' })
    res.end(`Upstream unavailable for ${stripPrefix}: ${error.message}`)
  })

  req.pipe(upstreamReq)
}

const server = http.createServer((req, res) => {
  const path = req.url || '/'
  const host = String(req.headers.host || '').toLowerCase().replace(/:\d+$/, '')

  if (hostRoutes[host]) {
    proxyRequest(req, res, hostRoutes[host], '')
    return
  }

  if (path === '/' || path === '') {
    res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' })
    res.end(indexHtml())
    return
  }

  if (path === '/healthz') {
    res.writeHead(200, { 'content-type': 'application/json; charset=utf-8' })
    res.end(JSON.stringify({ service: 'road-web-gateway', status: 'ok', port: PORT }))
    return
  }

  if (path === '/upstreams') {
    collectUpstreamStatus()
      .then(status => {
        const ok = Object.values(status).every(item => item.ok)
        res.writeHead(ok ? 200 : 503, { 'content-type': 'application/json; charset=utf-8' })
        res.end(JSON.stringify({
          service: 'road-web-gateway',
          status: ok ? 'ok' : 'degraded',
          checkedAt: new Date().toISOString(),
          upstreams: status,
        }, null, 2))
      })
      .catch(error => {
        res.writeHead(500, { 'content-type': 'application/json; charset=utf-8' })
        res.end(JSON.stringify({ service: 'road-web-gateway', status: 'error', error: error.message }))
      })
    return
  }

  for (const [prefix, upstream] of Object.entries(routes)) {
    if (path === prefix || path.startsWith(prefix + '/')) {
      proxyRequest(req, res, upstream, prefix)
      return
    }
  }

  res.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' })
  res.end('Not found')
})

server.listen(PORT, '127.0.0.1', () => {
  console.log(`Road web gateway listening on http://127.0.0.1:${PORT}`)
})
