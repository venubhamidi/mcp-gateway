# Deploy MCP Gateway to Railway

## Prerequisites

- Railway account (https://railway.app)
- Railway CLI installed (optional): `npm i -g @railway/cli`

## Option 1: Deploy via Railway Dashboard (Easiest)

### Step 1: Create New Project

1. Go to https://railway.app/new
2. Click "Deploy from GitHub repo" or "Empty Project"
3. If using GitHub:
   - Connect your GitHub account
   - Select this repository
   - Set root directory to: `mcp-gateway`
4. Railway will auto-detect the Dockerfile

### Step 2: Add PostgreSQL Database

1. In your Railway project, click "+ New"
2. Select "Database" → "PostgreSQL"
3. Railway will provision a Postgres database
4. Copy the `DATABASE_URL` (it's automatically available as `${{Postgres.DATABASE_URL}}`)

### Step 3: Configure Environment Variables

In Railway dashboard, add these variables:

```
MCPGATEWAY_UI_ENABLED=true
MCPGATEWAY_ADMIN_API_ENABLED=true
HOST=0.0.0.0
PORT=${{PORT}}
JWT_SECRET_KEY=<generate-random-32-char-string>
BASIC_AUTH_USER=admin
BASIC_AUTH_PASSWORD=<change-me>
AUTH_REQUIRED=true
DATABASE_URL=${{Postgres.DATABASE_URL}}
SECURE_COOKIES=true
```

### Step 4: Deploy

1. Click "Deploy"
2. Wait for build to complete
3. Railway will provide a public URL (e.g., `https://your-app.up.railway.app`)

### Step 5: Generate Bearer Token

Once deployed, generate a token locally:

```bash
docker run --rm -i ghcr.io/ibm/mcp-context-forge:0.8.0 \
  python3 -m mcpgateway.utils.create_jwt_token \
  --username admin \
  --exp 0 \
  --secret <your-JWT_SECRET_KEY>
```

Save this token - you'll need it for the Streamlit UI.

## Option 2: Deploy via Railway CLI

```bash
# Login to Railway
railway login

# Link to a project (or create new)
railway link

# Add PostgreSQL
railway add --plugin postgresql

# Set environment variables
railway variables set MCPGATEWAY_UI_ENABLED=true
railway variables set MCPGATEWAY_ADMIN_API_ENABLED=true
railway variables set HOST=0.0.0.0
railway variables set JWT_SECRET_KEY=$(openssl rand -hex 32)
railway variables set BASIC_AUTH_USER=admin
railway variables set BASIC_AUTH_PASSWORD=changeme
railway variables set AUTH_REQUIRED=true
railway variables set SECURE_COOKIES=true

# Deploy
railway up

# Get the URL
railway domain
```

## Option 3: Deploy from Subdirectory

If deploying from the parent AgenticAI directory:

1. In Railway dashboard → Settings → Build
2. Set "Root Directory" to: `mcp-gateway`
3. Keep "Dockerfile Path" as: `Dockerfile`

## After Deployment

### Access Your Gateway

- **Public URL**: `https://<your-app>.up.railway.app`
- **Admin UI**: `https://<your-app>.up.railway.app/admin`
- **API Docs**: `https://<your-app>.up.railway.app/docs`
- **Health Check**: `https://<your-app>.up.railway.app/health`

### Test the Deployment

```bash
# Check health
curl https://<your-app>.up.railway.app/health

# Should return: {"status":"healthy"}
```

### Generate Production Token

```bash
# Replace YOUR_SECRET with your JWT_SECRET_KEY from Railway
docker run --rm -i ghcr.io/ibm/mcp-context-forge:0.8.0 \
  python3 -m mcpgateway.utils.create_jwt_token \
  --username admin \
  --exp 0 \
  --secret YOUR_SECRET

# Save the output token
```

## Environment Variables Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MCPGATEWAY_UI_ENABLED` | Yes | `false` | Enable admin UI |
| `MCPGATEWAY_ADMIN_API_ENABLED` | Yes | `false` | Enable admin API |
| `HOST` | Yes | `127.0.0.1` | Bind host (use `0.0.0.0` for Railway) |
| `PORT` | No | `4444` | Port (Railway provides `${{PORT}}`) |
| `JWT_SECRET_KEY` | Yes | - | Secret for JWT signing |
| `BASIC_AUTH_USER` | Yes | - | Admin username |
| `BASIC_AUTH_PASSWORD` | Yes | - | Admin password |
| `AUTH_REQUIRED` | Yes | `false` | Require authentication |
| `DATABASE_URL` | Yes | - | PostgreSQL connection URL |
| `SECURE_COOKIES` | No | `false` | Use HTTPS cookies (set `true` for Railway) |

## Security Best Practices

1. **Change default credentials**: Don't use `admin/changeme`
2. **Use strong JWT secret**: Generate with `openssl rand -hex 32`
3. **Enable HTTPS**: Railway provides this automatically
4. **Rotate tokens**: Regenerate tokens periodically
5. **Monitor access**: Check logs in Railway dashboard

## Troubleshooting

### Build Fails

- Check logs in Railway dashboard
- Verify Dockerfile syntax
- Ensure all paths are correct

### Database Connection Issues

- Verify `DATABASE_URL` is set to `${{Postgres.DATABASE_URL}}`
- Check PostgreSQL plugin is added
- Restart the service

### Health Check Fails

- Check if port is set correctly (`0.0.0.0:${{PORT}}`)
- Verify database is connected
- Check logs for errors

## Cost Estimate

Railway pricing (as of 2024):
- **Hobby Plan**: $5/month for 500 hours
- **PostgreSQL**: Included in plan
- **Bandwidth**: First 100GB free

Typical usage: ~$5-10/month for small-medium usage

## Next Steps

After deploying the gateway:
1. Deploy the Streamlit UI (see `../streamlit-ui/DEPLOY.md`)
2. Configure UI to point to this gateway URL
3. Upload OpenAPI specs via the UI
