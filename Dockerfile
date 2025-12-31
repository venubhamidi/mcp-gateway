# MCP Gateway Docker Container
FROM ghcr.io/ibm/mcp-context-forge:1.0.0-BETA-1

# Expose the gateway port
EXPOSE 4444

# The base image already has the correct CMD, so we don't override it
