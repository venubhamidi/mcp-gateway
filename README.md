# MCP Gateway

Docker container running the IBM MCP Context Forge gateway.

## Features

- REST API to MCP tool conversion
- Streamable HTTP transport (MCP 2025-03-26)
- Admin UI for management
- PostgreSQL database for persistence
- JWT authentication

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Start gateway + database
docker-compose up -d

# View logs
docker-compose logs -f gateway

# Stop
docker-compose down
```

### Using Docker Directly

```bash
# Build
docker build -t mcp-gateway .

# Run
docker run -d \
  --name mcpgateway \
  -p 4444:4444 \
  --env-file .env \
  mcp-gateway
```

## Endpoints

- **Admin UI**: http://localhost:4444/admin
- **API Docs**: http://localhost:4444/docs
- **Health Check**: http://localhost:4444/health

## Default Credentials

- Username: `admin`
- Password: `changeme`

⚠️ **Change these in production!**

## Generate JWT Token

```bash
docker run --rm -i ghcr.io/ibm/mcp-context-forge:0.8.0 \
  python3 -m mcpgateway.utils.create_jwt_token \
  --username admin \
  --exp 0 \
  --secret your-jwt-secret
```

## Environment Variables

See `.env.example` for all available configuration options.
