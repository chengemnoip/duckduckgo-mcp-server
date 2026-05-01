FROM python:3.13-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir .

# MCP uses stdio, no port to expose.
CMD ["python", "-m", "duckduckgo_mcp_server.server"]
