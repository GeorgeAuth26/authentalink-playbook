#!/usr/bin/env node
// Thin wrapper: runs ECC GateGuard (vendored, pinned commit) as a Claude Code PreToolUse hook.
'use strict';
const { run } = require('./hooks/gateguard-fact-force.js');
let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', c => { raw += c; });
process.stdin.on('end', () => {
  let out;
  try { out = run(raw); } catch (e) { process.stderr.write(`[GateGuard] error, allowing: ${e.message}\n`); process.exit(0); }
  if (out && typeof out === 'object') {
    if (out.stderr) process.stderr.write(String(out.stderr) + '\n');
    if (out.stdout) process.stdout.write(String(out.stdout));
    process.exit(Number.isInteger(out.exitCode) ? out.exitCode : 0);
  }
  process.exit(0);
});
