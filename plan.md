# Set up the GitHub MCP server in this devcontainer

## Context

The official GitHub MCP plugin (`github@claude-plugins-official`) cannot authenticate via OAuth in Claude Code because the GitHub Copilot MCP endpoint does not support OAuth Dynamic Client Registration (RFC 7591). Authentication fails with:

```
SDK auth failed: Incompatible auth server: does not support dynamic client registration
```

The fix is to bypass OAuth entirely and authenticate with a GitHub Personal Access Token (PAT) passed via an `Authorization` header.

## Goal

Replace any existing OAuth-based GitHub MCP configuration with a token-based one that works inside a devcontainer.

## Steps

### 1. Confirm I have a PAT available

Ask me for a GitHub Personal Access Token if one is not already set. I should create a fine-grained PAT at https://github.com/settings/personal-access-tokens with the scopes I need (typically: repo contents, issues, pull requests, metadata).

**Do not hardcode the token in any committed file.** It must come from an environment variable.

### 2. Wire the token into the devcontainer

Edit `.devcontainer/devcontainer.json` to forward the token from the host into the container. Add (or merge into) the `containerEnv` section:

```json
{
  "containerEnv": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${localEnv:GITHUB_PERSONAL_ACCESS_TOKEN}"
  }
}
```

Remind me to `export GITHUB_PERSONAL_ACCESS_TOKEN=...` in my host shell (or add it to my host's `~/.bashrc` / `~/.zshrc` / shell profile) before rebuilding the container, otherwise the variable will be empty inside.

### 3. Remove any existing broken GitHub MCP configuration

Before adding the new config, clear out anything that might shadow it. Run each of these and ignore "not found" errors:

```bash
claude mcp remove github -s local 2>/dev/null || true
claude mcp remove github -s project 2>/dev/null || true
claude mcp remove github -s user 2>/dev/null || true
```

If the GitHub plugin from `claude-plugins-official` is enabled, disable it via `/plugin` so it does not conflict.

Also check for stale entries in:
- `~/.claude.json` (look under `projects[...]` for a `github` MCP entry)
- `.mcp.json` at the project root
- `.claude/settings.json`

Remove any `github` MCP server entry pointing to `https://api.githubcopilot.com/mcp/` without an `Authorization` header.

### 4. Add the working configuration

Create or update `.mcp.json` at the project root with this entry:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"
      }
    }
  }
}
```

If `.mcp.json` already exists with other servers, merge this entry into the existing `mcpServers` object — do not overwrite the file.

### 5. Add `.mcp.json` handling to `.gitignore` if needed

The config above references an env var, not the token itself, so `.mcp.json` is safe to commit. But double-check that no other file in the repo contains the literal token string before finishing.

### 6. Verify

Tell me to:

1. Rebuild the devcontainer (or run `echo $GITHUB_PERSONAL_ACCESS_TOKEN` to confirm the variable is set inside the container — it should print the token, not be empty).
2. Restart Claude Code.
3. Run `/mcp` and confirm the `github` server shows `Status: ✓ connected` with no authentication prompt.

If `/mcp` still shows a failure, check the output of `claude mcp list` for duplicate `github` entries across scopes (local > project > user precedence) and remove the duplicates.

## Done criteria

- `.devcontainer/devcontainer.json` forwards `GITHUB_PERSONAL_ACCESS_TOKEN`.
- `.mcp.json` has the `github` HTTP server with the `Authorization` header.
- No other `github` MCP entries exist in any scope.
- `/mcp` shows the GitHub server as connected.
- No token value is hardcoded in any committed file.