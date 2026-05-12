#!/usr/bin/env bash
set -euo pipefail

npm install -g \
  @anthropic-ai/claude-code \
  @google/gemini-cli \
  opencode-ai

gh extension install github/gh-copilot
