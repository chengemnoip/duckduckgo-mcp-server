# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Model Context Protocol (MCP) server providing DuckDuckGo web search and webpage content fetching. Built with Python using the FastMCP framework. Published to PyPI as `duckduckgo-mcp-server`.

## Commands

```bash
# Install dependencies
uv sync

# Run the server
uv run duckduckgo-mcp-server

# Run with MCP Inspector (for interactive testing)
mcp dev src/duckduckgo_mcp_server/server.py

# Run all tests
uv run python -m pytest src/duckduckgo_mcp_server/test_server.py

# Run a single test
uv run python -m pytest src/duckduckgo_mcp_server/test_server.py::TestRateLimiter::test_acquire_removes_expired_entries

# Build package
uv build
```

## Architecture

Single-module server in `src/duckduckgo_mcp_server/server.py` with three main classes:

- **`DuckDuckGoSearcher`** — Scrapes DuckDuckGo's HTML endpoint (`html.duckduckgo.com/html`) via POST requests. Parses results with BeautifulSoup. Handles SafeSearch (`kp` param) and region (`kl` param) configuration.
- **`WebContentFetcher`** — Fetches arbitrary URLs, strips non-content elements (script, style, nav, header, footer), and returns cleaned text truncated to 8000 chars.
- **`RateLimiter`** — Sliding-window rate limiter (30 req/min for search, 20 req/min for content fetching).

Two MCP tools are exposed: `search` and `fetch_content`.

## Configuration

Environment variables read at startup (not per-request):
- `DDG_SAFE_SEARCH`: `STRICT` | `MODERATE` (default) | `OFF`
- `DDG_REGION`: Region code like `us-en`, `cn-zh`, `jp-ja`, `wt-wt`

## Key Dependencies

- `mcp[cli]` (FastMCP framework)
- `httpx` (async HTTP client)
- `beautifulsoup4` (HTML parsing)
- Build system: `hatchling`
- Package manager: `uv`
