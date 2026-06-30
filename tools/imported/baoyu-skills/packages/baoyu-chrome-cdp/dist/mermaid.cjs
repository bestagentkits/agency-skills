var __create = Object.create;
var __getProtoOf = Object.getPrototypeOf;
var __defProp = Object.defineProperty;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __hasOwnProp = Object.prototype.hasOwnProperty;
function __accessProp(key) {
  return this[key];
}
var __toESMCache_node;
var __toESMCache_esm;
var __toESM = (mod, isNodeMode, target) => {
  var canCache = mod != null && typeof mod === "object";
  if (canCache) {
    var cache = isNodeMode ? __toESMCache_node ??= new WeakMap : __toESMCache_esm ??= new WeakMap;
    var cached = cache.get(mod);
    if (cached)
      return cached;
  }
  target = mod != null ? __create(__getProtoOf(mod)) : {};
  const to = isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target;
  for (let key of __getOwnPropNames(mod))
    if (!__hasOwnProp.call(to, key))
      __defProp(to, key, {
        get: __accessProp.bind(mod, key),
        enumerable: true
      });
  if (canCache)
    cache.set(mod, to);
  return to;
};
var __toCommonJS = (from) => {
  var entry = (__moduleCache ??= new WeakMap).get(from), desc;
  if (entry)
    return entry;
  entry = __defProp({}, "__esModule", { value: true });
  if (from && typeof from === "object" || typeof from === "function") {
    for (var key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(entry, key))
        __defProp(entry, key, {
          get: __accessProp.bind(from, key),
          enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable
        });
  }
  __moduleCache.set(from, entry);
  return entry;
};
var __moduleCache;
var __returnValue = (v) => v;
function __exportSetter(name, newValue) {
  this[name] = __returnValue.bind(null, newValue);
}
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, {
      get: all[name],
      enumerable: true,
      configurable: true,
      set: __exportSetter.bind(all, name)
    });
};

// src/mermaid.ts
var exports_mermaid = {};
__export(exports_mermaid, {
  renderMermaidToPng: () => renderMermaidToPng,
  closeRenderer: () => closeRenderer,
  MermaidRenderError: () => MermaidRenderError
});
module.exports = __toCommonJS(exports_mermaid);
var import_node_child_process2 = require("node:child_process");
var import_node_fs2 = __toESM(require("node:fs"));
var import_node_path2 = __toESM(require("node:path"));
var import_node_process2 = __toESM(require("node:process"));
var import_node_url = require("node:url");

// src/index.ts
var import_node_child_process = require("node:child_process");
var import_node_fs = __toESM(require("node:fs"));
var import_node_net = __toESM(require("node:net"));
var import_node_os = __toESM(require("node:os"));
var import_node_path = __toESM(require("node:path"));
var import_node_process = __toESM(require("node:process"));
function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
async function getFreePort(fixedEnvName) {
  const fixed = fixedEnvName ? Number.parseInt(import_node_process.default.env[fixedEnvName] ?? "", 10) : NaN;
  if (Number.isInteger(fixed) && fixed > 0)
    return fixed;
  return await new Promise((resolve, reject) => {
    const server = import_node_net.default.createServer();
    server.unref();
    server.on("error", reject);
    server.listen(0, "127.0.0.1", () => {
      const address = server.address();
      if (!address || typeof address === "string") {
        server.close(() => reject(new Error("Unable to allocate a free TCP port.")));
        return;
      }
      const port = address.port;
      server.close((err) => {
        if (err)
          reject(err);
        else
          resolve(port);
      });
    });
  });
}
function findChromeExecutable(options) {
  for (const envName of options.envNames ?? []) {
    const override = import_node_process.default.env[envName]?.trim();
    if (override && import_node_fs.default.existsSync(override))
      return override;
  }
  const candidates = import_node_process.default.platform === "darwin" ? options.candidates.darwin ?? options.candidates.default : import_node_process.default.platform === "win32" ? options.candidates.win32 ?? options.candidates.default : options.candidates.default;
  for (const candidate of candidates) {
    if (import_node_fs.default.existsSync(candidate))
      return candidate;
  }
  return;
}
function resolveSharedChromeProfileDir(options = {}) {
  for (const envName of options.envNames ?? []) {
    const override = import_node_process.default.env[envName]?.trim();
    if (override)
      return import_node_path.default.resolve(override);
  }
  const appDataDirName = options.appDataDirName ?? "baoyu-skills";
  const profileDirName = options.profileDirName ?? "chrome-profile";
  if (options.wslWindowsHome) {
    return import_node_path.default.join(options.wslWindowsHome, ".local", "share", appDataDirName, profileDirName);
  }
  const base = import_node_process.default.platform === "darwin" ? import_node_path.default.join(import_node_os.default.homedir(), "Library", "Application Support") : import_node_process.default.platform === "win32" ? import_node_process.default.env.APPDATA ?? import_node_path.default.join(import_node_os.default.homedir(), "AppData", "Roaming") : import_node_process.default.env.XDG_DATA_HOME ?? import_node_path.default.join(import_node_os.default.homedir(), ".local", "share");
  return import_node_path.default.join(base, appDataDirName, profileDirName);
}
async function fetchWithTimeout(url, timeoutMs) {
  if (!timeoutMs || timeoutMs <= 0)
    return await fetch(url, { redirect: "follow" });
  const ctl = new AbortController;
  const timer = setTimeout(() => ctl.abort(), timeoutMs);
  try {
    return await fetch(url, { redirect: "follow", signal: ctl.signal });
  } finally {
    clearTimeout(timer);
  }
}
async function fetchJson(url, options = {}) {
  const response = await fetchWithTimeout(url, options.timeoutMs);
  if (!response.ok) {
    throw new Error(`Request failed: ${response.status} ${response.statusText}`);
  }
  return await response.json();
}
async function isDebugPortReady(port, timeoutMs = 3000) {
  try {
    const version = await fetchJson(`http://127.0.0.1:${port}/json/version`, { timeoutMs });
    return !!version.webSocketDebuggerUrl;
  } catch {
    return false;
  }
}
function parseDevToolsActivePort(filePath) {
  try {
    const content = import_node_fs.default.readFileSync(filePath, "utf-8");
    const lines = content.split(/\r?\n/);
    const port = Number.parseInt(lines[0]?.trim() ?? "", 10);
    const wsPath = lines[1]?.trim();
    if (port > 0 && wsPath)
      return { port, wsPath };
  } catch {}
  return null;
}
async function findExistingChromeDebugPort(options) {
  const timeoutMs = options.timeoutMs ?? 3000;
  const parsed = parseDevToolsActivePort(import_node_path.default.join(options.profileDir, "DevToolsActivePort"));
  if (parsed && parsed.port > 0 && await isDebugPortReady(parsed.port, timeoutMs))
    return parsed.port;
  if (import_node_process.default.platform === "win32")
    return null;
  try {
    const result = import_node_child_process.spawnSync("ps", ["aux"], { encoding: "utf-8", timeout: 5000 });
    if (result.status !== 0 || !result.stdout)
      return null;
    const lines = result.stdout.split(`
`).filter((line) => line.includes(options.profileDir) && line.includes("--remote-debugging-port="));
    for (const line of lines) {
      const portMatch = line.match(/--remote-debugging-port=(\d+)/);
      const port = Number.parseInt(portMatch?.[1] ?? "", 10);
      if (port > 0 && await isDebugPortReady(port, timeoutMs))
        return port;
    }
  } catch {}
  return null;
}
async function waitForChromeDebugPort(port, timeoutMs, options) {
  const start = Date.now();
  let lastError = null;
  while (Date.now() - start < timeoutMs) {
    try {
      const version = await fetchJson(`http://127.0.0.1:${port}/json/version`, { timeoutMs: 5000 });
      if (version.webSocketDebuggerUrl)
        return version.webSocketDebuggerUrl;
      lastError = new Error("Missing webSocketDebuggerUrl");
    } catch (error) {
      lastError = error;
    }
    await sleep(200);
  }
  if (options?.includeLastError && lastError) {
    throw new Error(`Chrome debug port not ready: ${lastError instanceof Error ? lastError.message : String(lastError)}`);
  }
  throw new Error("Chrome debug port not ready");
}

class CdpConnection {
  ws;
  nextId = 0;
  pending = new Map;
  eventHandlers = new Map;
  defaultTimeoutMs;
  constructor(ws, defaultTimeoutMs = 15000) {
    this.ws = ws;
    this.defaultTimeoutMs = defaultTimeoutMs;
    this.ws.addEventListener("message", (event) => {
      try {
        const data = typeof event.data === "string" ? event.data : new TextDecoder().decode(event.data);
        const msg = JSON.parse(data);
        if (msg.method) {
          const handlers = this.eventHandlers.get(msg.method);
          if (handlers) {
            handlers.forEach((handler) => handler(msg.params));
          }
        }
        if (msg.id) {
          const pending = this.pending.get(msg.id);
          if (pending) {
            this.pending.delete(msg.id);
            if (pending.timer)
              clearTimeout(pending.timer);
            if (msg.error?.message)
              pending.reject(new Error(msg.error.message));
            else
              pending.resolve(msg.result);
          }
        }
      } catch {}
    });
    this.ws.addEventListener("close", () => {
      for (const [id, pending] of this.pending.entries()) {
        this.pending.delete(id);
        if (pending.timer)
          clearTimeout(pending.timer);
        pending.reject(new Error("CDP connection closed."));
      }
    });
  }
  static async connect(url, timeoutMs, options) {
    const ws = new WebSocket(url);
    await new Promise((resolve, reject) => {
      const timer = setTimeout(() => reject(new Error("CDP connection timeout.")), timeoutMs);
      ws.addEventListener("open", () => {
        clearTimeout(timer);
        resolve();
      });
      ws.addEventListener("error", () => {
        clearTimeout(timer);
        reject(new Error("CDP connection failed."));
      });
    });
    return new CdpConnection(ws, options?.defaultTimeoutMs ?? 15000);
  }
  on(method, handler) {
    if (!this.eventHandlers.has(method)) {
      this.eventHandlers.set(method, new Set);
    }
    this.eventHandlers.get(method)?.add(handler);
  }
  off(method, handler) {
    this.eventHandlers.get(method)?.delete(handler);
  }
  async send(method, params, options) {
    const id = ++this.nextId;
    const message = { id, method };
    if (params)
      message.params = params;
    if (options?.sessionId)
      message.sessionId = options.sessionId;
    const timeoutMs = options?.timeoutMs ?? this.defaultTimeoutMs;
    const result = await new Promise((resolve, reject) => {
      const timer = timeoutMs > 0 ? setTimeout(() => {
        this.pending.delete(id);
        reject(new Error(`CDP timeout: ${method}`));
      }, timeoutMs) : null;
      this.pending.set(id, { resolve, reject, timer });
      this.ws.send(JSON.stringify(message));
    });
    return result;
  }
  close() {
    try {
      this.ws.close();
    } catch {}
  }
}
async function launchChrome(options) {
  await import_node_fs.default.promises.mkdir(options.profileDir, { recursive: true });
  const args = [
    `--remote-debugging-port=${options.port}`,
    `--user-data-dir=${options.profileDir}`,
    "--no-first-run",
    "--no-default-browser-check",
    ...options.extraArgs ?? []
  ];
  if (options.headless)
    args.push("--headless=new");
  if (options.url)
    args.push(options.url);
  return import_node_child_process.spawn(options.chromePath, args, { stdio: "ignore" });
}
async function openPageSession(options) {
  let targetId;
  let createdTarget = false;
  if (options.reusing) {
    const created = await options.cdp.send("Target.createTarget", { url: options.url });
    targetId = created.targetId;
    createdTarget = true;
  } else {
    const targets = await options.cdp.send("Target.getTargets");
    const existing = targets.targetInfos.find(options.matchTarget);
    if (existing) {
      targetId = existing.targetId;
    } else {
      const created = await options.cdp.send("Target.createTarget", { url: options.url });
      targetId = created.targetId;
      createdTarget = true;
    }
  }
  const { sessionId } = await options.cdp.send("Target.attachToTarget", { targetId, flatten: true });
  if (options.activateTarget ?? true) {
    await options.cdp.send("Target.activateTarget", { targetId });
  }
  if (options.enablePage)
    await options.cdp.send("Page.enable", {}, { sessionId });
  if (options.enableRuntime)
    await options.cdp.send("Runtime.enable", {}, { sessionId });
  if (options.enableDom)
    await options.cdp.send("DOM.enable", {}, { sessionId });
  if (options.enableNetwork)
    await options.cdp.send("Network.enable", {}, { sessionId });
  return { sessionId, targetId, createdTarget };
}

// src/mermaid.ts
class MermaidRenderError extends Error {
  constructor(message, options) {
    super(message);
    this.name = "MermaidRenderError";
    if (options?.cause !== undefined) {
      this.cause = options.cause;
    }
  }
}
function resolveRenderScale(scale) {
  const resolved = scale ?? 2;
  if (!Number.isFinite(resolved) || resolved <= 0) {
    throw new MermaidRenderError(`Invalid Mermaid render scale: ${scale}`);
  }
  return resolved;
}
function resolveMinWidth(minWidth) {
  if (minWidth === undefined)
    return;
  if (!Number.isFinite(minWidth) || minWidth <= 0) {
    throw new MermaidRenderError(`Invalid Mermaid render minWidth: ${minWidth}`);
  }
  return minWidth;
}
var CHROME_CANDIDATES = {
  darwin: [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary",
    "/Applications/Google Chrome Beta.app/Contents/MacOS/Google Chrome Beta",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
  ],
  win32: [
    "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
    "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
    "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
    "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
  ],
  default: [
    "/usr/bin/google-chrome",
    "/usr/bin/google-chrome-stable",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser",
    "/snap/bin/chromium",
    "/usr/bin/microsoft-edge"
  ]
};
var wslHome;
function getWslWindowsHome() {
  if (wslHome !== undefined)
    return wslHome;
  if (!import_node_process2.default.env.WSL_DISTRO_NAME) {
    wslHome = null;
    return null;
  }
  try {
    const raw = import_node_child_process2.execSync('cmd.exe /C "echo %USERPROFILE%"', {
      encoding: "utf-8",
      timeout: 5000
    }).trim().replace(/\r/g, "");
    wslHome = import_node_child_process2.execSync(`wslpath -u "${raw}"`, {
      encoding: "utf-8",
      timeout: 5000
    }).trim() || null;
  } catch {
    wslHome = null;
  }
  return wslHome;
}
function getProfileDir() {
  return resolveSharedChromeProfileDir({
    envNames: ["BAOYU_CHROME_PROFILE_DIR", "MERMAID_RENDER_PROFILE_DIR"],
    wslWindowsHome: getWslWindowsHome()
  });
}
function resolveAssetsDir() {
  const here = import_node_url.fileURLToPath(undefined);
  const dir = import_node_path2.default.dirname(here);
  const candidates = [
    import_node_path2.default.resolve(dir, "..", "assets"),
    import_node_path2.default.resolve(dir, "assets")
  ];
  for (const candidate of candidates) {
    if (import_node_fs2.default.existsSync(import_node_path2.default.join(candidate, "mermaid.min.js")))
      return candidate;
  }
  throw new MermaidRenderError(`Cannot locate mermaid.min.js. Looked in: ${candidates.join(", ")}`);
}
var cachedMermaidScript = null;
function loadMermaidScript() {
  if (cachedMermaidScript)
    return cachedMermaidScript;
  const assetsDir = resolveAssetsDir();
  cachedMermaidScript = import_node_fs2.default.readFileSync(import_node_path2.default.join(assetsDir, "mermaid.min.js"), "utf-8");
  return cachedMermaidScript;
}
var rendererState = null;
var connectingPromise = null;
var exitHookInstalled = false;
function installExitHook() {
  if (exitHookInstalled)
    return;
  exitHookInstalled = true;
  const cleanup = () => {
    const state = rendererState;
    rendererState = null;
    if (!state)
      return;
    try {
      state.cdp.close();
    } catch {}
    if (state.ownsChrome && state.chrome) {
      try {
        state.chrome.kill("SIGTERM");
      } catch {}
    }
  };
  import_node_process2.default.on("exit", cleanup);
  import_node_process2.default.on("beforeExit", cleanup);
}
async function tryConnectExisting(port) {
  try {
    const wsUrl = await waitForChromeDebugPort(port, 5000, { includeLastError: true });
    return await CdpConnection.connect(wsUrl, 5000);
  } catch {
    return null;
  }
}
async function ensureRenderer() {
  if (rendererState)
    return rendererState;
  if (connectingPromise)
    return await connectingPromise;
  connectingPromise = (async () => {
    const profileDir = getProfileDir();
    const existingPort = await findExistingChromeDebugPort({ profileDir });
    if (existingPort) {
      const cdp2 = await tryConnectExisting(existingPort);
      if (cdp2) {
        const state2 = {
          cdp: cdp2,
          chrome: null,
          port: existingPort,
          ownsChrome: false
        };
        rendererState = state2;
        installExitHook();
        return state2;
      }
    }
    const chromePath = findChromeExecutable({
      candidates: CHROME_CANDIDATES,
      envNames: ["BAOYU_CHROME_PATH", "MERMAID_RENDER_CHROME_PATH"]
    });
    if (!chromePath) {
      throw new MermaidRenderError("Chrome not found. Install Google Chrome / Chromium / Edge, or set BAOYU_CHROME_PATH.");
    }
    const port = await getFreePort("MERMAID_RENDER_DEBUG_PORT");
    const chrome = await launchChrome({
      chromePath,
      profileDir,
      port,
      headless: true,
      extraArgs: [
        "--disable-blink-features=AutomationControlled",
        "--disable-gpu",
        "--hide-scrollbars"
      ]
    });
    const wsUrl = await waitForChromeDebugPort(port, 30000, { includeLastError: true });
    const cdp = await CdpConnection.connect(wsUrl, 30000);
    const state = { cdp, chrome, port, ownsChrome: true };
    rendererState = state;
    installExitHook();
    return state;
  })();
  try {
    return await connectingPromise;
  } finally {
    connectingPromise = null;
  }
}
function buildHostHtml(code, theme, background) {
  const script = loadMermaidScript();
  const safeCode = code.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  const safeTheme = JSON.stringify(theme);
  const cssBackground = background === "transparent" ? "transparent" : background;
  return `<!doctype html>
<html>
<head>
<meta charset="utf-8">
<style>
  html, body {
    margin: 0;
    padding: 0;
    background: ${cssBackground};
    font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", "Microsoft YaHei", "Hiragino Sans GB", "Noto Sans CJK SC", sans-serif;
  }
  #host {
    display: inline-block;
    padding: 16px;
  }
  #host svg {
    max-width: none !important;
  }
</style>
</head>
<body>
<div id="host"><div class="mermaid">${safeCode}</div></div>
<script>${script}</script>
<script>
  window.__mermaidReady = false;
  window.__mermaidError = null;
  try {
    mermaid.initialize({ startOnLoad: false, theme: ${safeTheme}, securityLevel: "loose" });
    mermaid.run({ querySelector: ".mermaid" })
      .then(function () { window.__mermaidReady = true; })
      .catch(function (err) { window.__mermaidError = String(err && err.message || err); });
  } catch (err) {
    window.__mermaidError = String(err && err.message || err);
  }
</script>
</body>
</html>`;
}
async function evaluate(cdp, sessionId, expression) {
  const result = await cdp.send("Runtime.evaluate", {
    expression,
    returnByValue: true,
    awaitPromise: false
  }, { sessionId });
  const exception = result.exceptionDetails;
  if (exception) {
    return {
      value: undefined,
      exceptionText: exception.exception?.description ?? exception.text ?? "evaluation failed"
    };
  }
  return { value: result.result.value };
}
async function waitForMermaidSvg(cdp, sessionId, timeoutMs) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    const status = await evaluate(cdp, sessionId, `(function () {
        if (window.__mermaidError) {
          return { ready: false, error: window.__mermaidError, rect: null };
        }
        var svg = document.querySelector(".mermaid svg");
        if (!svg) return { ready: false, error: null, rect: null };
        var bbox = svg.getBoundingClientRect();
        return {
          ready: window.__mermaidReady === true,
          error: null,
          rect: {
            x: bbox.x,
            y: bbox.y,
            width: bbox.width,
            height: bbox.height,
          },
        };
      })()`);
    if (status.exceptionText) {
      throw new MermaidRenderError(`Mermaid evaluation failed: ${status.exceptionText}`);
    }
    const value = status.value;
    if (value?.error) {
      throw new MermaidRenderError(`Mermaid render failed: ${value.error}`);
    }
    if (value?.ready && value.rect && value.rect.width > 0 && value.rect.height > 0) {
      const host = await evaluate(cdp, sessionId, `(function () {
          var host = document.getElementById("host");
          if (!host) return null;
          var rect = host.getBoundingClientRect();
          return { x: rect.x, y: rect.y, width: rect.width, height: rect.height };
        })()`);
      if (host.value)
        return host.value;
      return value.rect;
    }
    await sleep(80);
  }
  throw new MermaidRenderError(`Mermaid render timed out after ${timeoutMs}ms`);
}
async function withPageSession(state, fn) {
  let session = null;
  try {
    session = await openPageSession({
      cdp: state.cdp,
      reusing: !state.ownsChrome,
      url: "about:blank",
      matchTarget: () => false,
      enablePage: true,
      enableRuntime: true
    });
    return await fn(session.sessionId, session.targetId);
  } finally {
    if (session?.createdTarget) {
      try {
        await state.cdp.send("Target.closeTarget", { targetId: session.targetId });
      } catch {}
    }
  }
}
async function renderMermaidToPng(code, outputPath, options = {}) {
  const theme = options.theme ?? "default";
  const scale = resolveRenderScale(options.scale);
  const minWidth = resolveMinWidth(options.minWidth);
  const background = options.background ?? "white";
  const timeoutMs = options.timeoutMs ?? 15000;
  if (!code.trim()) {
    throw new MermaidRenderError("Mermaid code is empty");
  }
  await import_node_fs2.default.promises.mkdir(import_node_path2.default.dirname(outputPath), { recursive: true });
  const state = await ensureRenderer();
  const html = buildHostHtml(code, theme, background);
  return await withPageSession(state, async (sessionId) => {
    await state.cdp.send("Emulation.setDeviceMetricsOverride", {
      width: 1280,
      height: 800,
      deviceScaleFactor: 1,
      mobile: false
    }, { sessionId });
    await state.cdp.send("Page.setDocumentContent", { frameId: await getFrameId(state.cdp, sessionId), html }, { sessionId });
    const rect = await waitForMermaidSvg(state.cdp, sessionId, timeoutMs);
    const cssWidth = Math.max(1, Math.ceil(rect.width));
    const cssHeight = Math.max(1, Math.ceil(rect.height));
    const targetCssWidth = Math.max(cssWidth, Math.ceil(minWidth ?? cssWidth));
    const captureScale = scale * (targetCssWidth / cssWidth);
    const bitmapWidth = Math.max(1, Math.ceil(cssWidth * captureScale));
    const bitmapHeight = Math.max(1, Math.ceil(cssHeight * captureScale));
    await state.cdp.send("Emulation.setDeviceMetricsOverride", {
      width: cssWidth,
      height: cssHeight,
      deviceScaleFactor: 1,
      mobile: false
    }, { sessionId });
    const shot = await state.cdp.send("Page.captureScreenshot", {
      format: "png",
      clip: {
        x: rect.x,
        y: rect.y,
        width: cssWidth,
        height: cssHeight,
        scale: captureScale
      },
      captureBeyondViewport: true
    }, { sessionId });
    const buffer = Buffer.from(shot.data, "base64");
    await import_node_fs2.default.promises.writeFile(outputPath, buffer);
    return {
      width: bitmapWidth,
      height: bitmapHeight,
      bytes: buffer.length
    };
  });
}
async function getFrameId(cdp, sessionId) {
  const result = await cdp.send("Page.getFrameTree", {}, { sessionId });
  return result.frameTree.frame.id;
}
async function closeRenderer() {
  const state = rendererState;
  rendererState = null;
  if (!state)
    return;
  try {
    state.cdp.close();
  } catch {}
  if (state.ownsChrome && state.chrome) {
    try {
      state.chrome.kill("SIGTERM");
    } catch {}
  }
}
