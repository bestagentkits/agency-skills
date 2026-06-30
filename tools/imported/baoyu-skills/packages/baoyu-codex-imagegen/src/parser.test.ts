import { test, expect } from "bun:test";
import { parseEventStream, hasImageGenInvocation } from "./parser.ts";

const REAL_PoC_STREAM = `{"type":"thread.started","thread_id":"019e40d3-30e3-7030-874d-773bc0d6d1eb"}
{"type":"turn.started"}
{"type":"item.started","item":{"id":"item_0","type":"command_execution","command":"sed -n '1,5p' /tmp/x.md","status":"in_progress"}}
{"type":"item.completed","item":{"id":"item_0","type":"command_execution","command":"sed -n '1,5p' /tmp/x.md","exit_code":0,"status":"completed"}}
{"type":"item.started","item":{"id":"item_1","type":"command_execution","command":"cp /Users/x/.codex/generated_images/019e40d3/ig_abc.png /tmp/out.png","status":"in_progress"}}
{"type":"item.completed","item":{"id":"item_1","type":"command_execution","command":"cp /Users/x/.codex/generated_images/019e40d3/ig_abc.png /tmp/out.png","exit_code":0,"status":"completed"}}
{"type":"item.completed","item":{"id":"item_2","type":"agent_message","text":"{\\"status\\":\\"ok\\",\\"path\\":\\"/tmp/out.png\\",\\"bytes\\":1234567}"}}
{"type":"turn.completed","usage":{"input_tokens":100000,"cached_input_tokens":80000,"output_tokens":500,"reasoning_output_tokens":50}}`;

test("parseEventStream extracts threadId, toolCalls, agentMessage, usage", () => {
  const r = parseEventStream(REAL_PoC_STREAM);
  expect(r.threadId).toBe("019e40d3-30e3-7030-874d-773bc0d6d1eb");
  expect(r.toolCalls.length).toBe(3);
  expect(r.usage).toEqual({
    input: 100000,
    cached_input: 80000,
    output: 500,
    reasoning: 50,
  });
  expect(r.agentMessage).toContain('"status":"ok"');
});

test("parseEventStream tolerates malformed lines", () => {
  const stream = `not json at all
{"type":"thread.started","thread_id":"abc"}
{partial json
{"type":"turn.completed","usage":{"input_tokens":1,"cached_input_tokens":0,"output_tokens":1,"reasoning_output_tokens":0}}`;
  const r = parseEventStream(stream);
  expect(r.threadId).toBe("abc");
  expect(r.usage?.input).toBe(1);
});

test("hasImageGenInvocation does not infer image_gen from shell copies", () => {
  const r = parseEventStream(REAL_PoC_STREAM);
  const hasCp = r.toolCalls.some((tc) => tc.command?.includes("generated_images"));
  expect(hasCp).toBe(true);
  expect(hasImageGenInvocation(r.toolCalls)).toBe(false);
});

test("hasImageGenInvocation detects real image_gen tool calls only", () => {
  expect(hasImageGenInvocation([{ id: "1", tool: "shell", status: "completed" }])).toBe(false);
  expect(
    hasImageGenInvocation([{ id: "1", tool: "image_gen", status: "completed" }]),
  ).toBe(true);
});

test("parseEventStream normalizes an image_generation item to image_gen", () => {
  const stream = `{"type":"thread.started","thread_id":"t1"}
{"type":"item.started","item":{"id":"g0","type":"image_generation","status":"in_progress"}}
{"type":"item.completed","item":{"id":"g0","type":"image_generation","status":"completed"}}
{"type":"item.completed","item":{"id":"m0","type":"agent_message","text":"done"}}`;
  const r = parseEventStream(stream);
  expect(r.toolCalls.some((tc) => tc.tool === "image_gen")).toBe(true);
  expect(hasImageGenInvocation(r.toolCalls)).toBe(true);
});
