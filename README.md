# Zero Config Devcontainer

> A language-agnostic GitHub Template Repository with a fully configured dev container, GitHub Codespaces support, Docker-in-Docker, and AI coding assistants (Claude Code, GitHub Copilot, Gemini) ready out of the box.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/mr-pedro-damasio/zero-config-devcontainer)

---

## Overview

This template provides a zero-configuration starting point for any new project. The development environment runs identically in GitHub Codespaces and in a local VS Code dev container. Language runtimes, frameworks, and project-specific tooling are intentionally left out — they are added after the project is created from this template.

---

## Getting Started

### Option 1 — GitHub Codespaces (recommended)

1. Click **Open in GitHub Codespaces** above, or go to **Code → Codespaces → New codespace**.
2. Wait for the environment to build (first run takes a few minutes).
3. Copy `.env.example` to `.env` and fill in the required values.
4. You're ready to develop.

### Option 2 — Dev Container (local)

**Prerequisites:** [Docker Desktop](https://www.docker.com/products/docker-desktop) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code.

1. Clone the repository.
2. Open the project in VS Code.
3. When prompted, click **Reopen in Container** (or run `Dev Containers: Reopen in Container` from the command palette).
4. Copy `.env.example` to `.env` and fill in the required values.
5. You're ready to develop.

---

## Environment Variables

All configuration is managed via environment variables. See `.env.example` for the full list with descriptions.

```bash
cp .env.example .env
# Edit .env with your values
```

> **Never commit `.env` to version control.**

---

## Docker

This project uses Docker for production builds. The dev container has Docker-in-Docker enabled, so you can build and run production images directly from your development environment.

```bash
# Build the production image
docker build -t zero-config-devcontainer .

# Run the production container
docker run --env-file .env zero-config-devcontainer
```

---

## AI Tools

The following AI coding assistants are pre-installed and available in this environment:

| Tool | CLI | VS Code Extension |
|------|-----|-------------------|
| [Claude Code](https://claude.ai/code) | `claude` | Anthropic Claude Code |
| [GitHub Copilot](https://github.com/features/copilot) | `gh copilot` | GitHub Copilot |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `gemini` | Gemini Code Assist |

---

## Development

<!-- Add project-specific development instructions here once the stack is defined. -->

---

## Contributing

<!-- Add contribution guidelines here. -->
