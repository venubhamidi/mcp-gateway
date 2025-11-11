# MCP Gateway Docker Container
FROM ghcr.io/ibm/mcp-context-forge:0.8.0

# Expose the gateway port
EXPOSE 4444

# The base image already has the correct CMD, so we don't override it
