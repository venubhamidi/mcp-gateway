# MCP Gateway Docker Container
FROM ghcr.io/ibm/mcp-context-forge:0.8.0

# Expose the gateway port
EXPOSE 4444

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python3 -c "import requests; requests.get('http://localhost:4444/health')" || exit 1

# Run the gateway
CMD ["python3", "-m", "mcpgateway"]
