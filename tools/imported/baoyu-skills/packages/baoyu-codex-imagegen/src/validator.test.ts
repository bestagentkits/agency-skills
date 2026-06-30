import { test, expect } from "bun:test";
import { mkdtemp, writeFile, rm, mkdir } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { verifyOutput, verifyImageGenWasInvoked, hasImageGenEvidence } from "./validator.ts";
import { parseEventStream } from "./parser.ts";
import { GenError } from "./types.ts";

const PNG_HEADER = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

// Condensed + sanitized capture of a REAL successful `codex exec --json` run
// (thread 019edc1c…, 16:9 maple-tree image, single attempt). The image_gen
// tool leaves NO stream item — success shows only reasoning / command_execution
// / agent_message, and a `cp` from generated_images/<FULL-thread-id>/ig_*.png.
const REAL_SUCCESS_STREAM = `{"type":"thread.started","thread_id":"019edc1c-e7a3-74f0-a276-13bea71d32d6"}
{"type":"turn.started"}
{"type":"item.completed","item":{"id":"r0","type":"reasoning"}}
{"type":"item.completed","item":{"id":"r1","type":"reasoning"}}
{"type":"item.completed","item":{"id":"m0","type":"agent_message","text":"Image generation is complete. Locating the newly produced image and copying it to the requested path."}}
{"type":"item.started","item":{"id":"c0","type":"command_execution","command":"ls $CODEX_HOME/generated_images","status":"in_progress"}}
{"type":"item.completed","item":{"id":"c0","type":"command_execution","command":"ls $CODEX_HOME/generated_images","exit_code":1,"status":"failed"}}
{"type":"item.started","item":{"id":"c1","type":"command_execution","command":"cp $CODEX_HOME/generated_images/019edc1c-e7a3-74f0-a276-13bea71d32d6/ig_03eda661.png /Users/x/out/maple.png","status":"in_progress"}}
{"type":"item.completed","item":{"id":"c1","type":"command_execution","command":"cp $CODEX_HOME/generated_images/019edc1c-e7a3-74f0-a276-13bea71d32d6/ig_03eda661.png /Users/x/out/maple.png","exit_code":0,"status":"completed"}}
{"type":"item.completed","item":{"id":"m1","type":"agent_message","text":"{\\"status\\":\\"ok\\",\\"path\\":\\"/Users/x/out/maple.png\\",\\"bytes\\":1317377}"}}
{"type":"turn.completed","usage":{"input_tokens":49489,"cached_input_tokens":34432,"output_tokens":2463,"reasoning_output_tokens":1990}}`;

test("real success stream carries no image_gen item — gating on the stream alone would false-negative (#185)", () => {
  const r = parseEventStream(REAL_SUCCESS_STREAM);
  expect(r.threadId).toBe("019edc1c-e7a3-74f0-a276-13bea71d32d6");
  // success path tools: reasoning / shell / agent_message — never image_gen
  expect(r.toolCalls.map((tc) => tc.tool).sort()).toEqual([
    "agent_message",
    "agent_message",
    "reasoning",
    "reasoning",
    "shell",
    "shell",
  ]);
  expect(r.toolCalls.some((tc) => tc.tool === "image_gen")).toBe(false);
  // filesystem evidence (PNG in this thread's dir) is what must let it through
  expect(hasImageGenEvidence(r.toolCalls, true)).toBe(true);
  // with no filesystem evidence and no stream item, it is rejected (the shortcut)
  expect(hasImageGenEvidence(r.toolCalls, false)).toBe(false);
});

test("hasImageGenEvidence accepts a real image_gen stream item even without a dir PNG", () => {
  expect(hasImageGenEvidence([{ id: "1", tool: "image_gen", status: "completed" }], false)).toBe(true);
  expect(hasImageGenEvidence([{ id: "1", tool: "shell", status: "completed" }], false)).toBe(false);
});

test("verifyOutput passes for valid PNG", async () => {
  const dir = await mkdtemp(path.join(tmpdir(), "cig-val-"));
  try {
    const p = path.join(dir, "good.png");
    await writeFile(p, Buffer.concat([PNG_HEADER, Buffer.alloc(5000)]));
    const r = await verifyOutput(p);
    expect(r.bytes).toBeGreaterThan(1000);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});

test("verifyOutput rejects missing file", async () => {
  await expect(verifyOutput("/no/such/file.png")).rejects.toBeInstanceOf(GenError);
});

test("verifyOutput rejects tiny file", async () => {
  const dir = await mkdtemp(path.join(tmpdir(), "cig-val-"));
  try {
    const p = path.join(dir, "tiny.png");
    await writeFile(p, "tiny");
    await expect(verifyOutput(p)).rejects.toThrow(/too small/);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});

test("verifyOutput rejects non-PNG magic", async () => {
  const dir = await mkdtemp(path.join(tmpdir(), "cig-val-"));
  try {
    const p = path.join(dir, "fake.png");
    await writeFile(p, Buffer.concat([Buffer.from("GIF89a"), Buffer.alloc(5000)]));
    await expect(verifyOutput(p)).rejects.toThrow(/not a valid PNG/);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
});

test("verifyImageGenWasInvoked false when no thread directory", async () => {
  const orig = process.env.CODEX_HOME;
  const tempHome = await mkdtemp(path.join(tmpdir(), "cig-home-"));
  process.env.CODEX_HOME = tempHome;
  try {
    const r = await verifyImageGenWasInvoked("no-such-thread");
    expect(r.ok).toBe(false);
  } finally {
    process.env.CODEX_HOME = orig;
    await rm(tempHome, { recursive: true, force: true });
  }
});

test("verifyImageGenWasInvoked true when PNG exists in thread dir", async () => {
  const orig = process.env.CODEX_HOME;
  const tempHome = await mkdtemp(path.join(tmpdir(), "cig-home-"));
  process.env.CODEX_HOME = tempHome;
  try {
    const threadDir = path.join(tempHome, "generated_images", "thread-xyz");
    await mkdir(threadDir, { recursive: true });
    await writeFile(path.join(threadDir, "ig_abc.png"), Buffer.alloc(100));
    const r = await verifyImageGenWasInvoked("thread-xyz");
    expect(r.ok).toBe(true);
  } finally {
    process.env.CODEX_HOME = orig;
    await rm(tempHome, { recursive: true, force: true });
  }
});
