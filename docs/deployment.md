# Deployment Guide

---

## Building the Flutter App

### Prerequisites

- Flutter SDK >=3.2.0
- Android SDK (for APK/AAB builds)
- Xcode (for iOS builds — macOS only)
- Configured `API_BASE_URL` for production

### Environment Configuration

Set the production API URL at build time:

```bash
# APK
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.insightwallet.com

# App Bundle (Google Play)
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://api.insightwallet.com

# iOS (App Store)
flutter build ios --release \
  --dart-define=API_BASE_URL=https://api.insightwallet.com
```

### Build Outputs

| Command                          | Output Path                                      |
|----------------------------------|--------------------------------------------------|
| `flutter build apk --release`    | `build/app/outputs/flutter-apk/app-release.apk`   |
| `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| `flutter build ios --release`    | `build/ios/ipa/*.ipa`                             |

### Code Generation

Before any build, ensure generated files are up to date:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Code Signing (Android)

Create a keystore and configure signing in `android/app/build.gradle`:

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -alias upload -keyalg RSA -keysize 2048 \
  -validity 10000
```

Create `android/key.properties`:
```
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=upload
storeFile=../upload-keystore.jks
```

### Code Signing (iOS)

Use Xcode or Fastlane to manage provisioning profiles and certificates.

---

## Building the Express Backend

### Production Dependencies

```bash
cd apps/backend
npm ci --omit=dev    # Clean install, production only
```

### Start Script

Run the server directly:

```bash
NODE_ENV=production node src/server.js
```

---

## PM2 Process Management

Use PM2 to run the backend as a persistent service.

### Installation

```bash
npm install -g pm2
```

### Start with PM2

```bash
# Start
pm2 start apps/backend/src/server.js \
  --name insightwallet-api \
  --node-args="--experimental-modules" \
  --env NODE_ENV=production

# Or with ecosystem file
```

### PM2 Ecosystem File

Create `ecosystem.config.cjs` in the project root:

```javascript
module.exports = {
  apps: [{
    name: 'insightwallet-api',
    script: 'apps/backend/src/server.js',
    instances: 2,                    // Cluster mode with 2 instances
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 5000,
    },
    env_file: 'apps/backend/.env',
    max_memory_restart: '500M',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    error_file: 'logs/api-error.log',
    out_file: 'logs/api-out.log',
    merge_logs: true,
  }],
};
```

### Useful PM2 Commands

```bash
pm2 start ecosystem.config.cjs     # Start all apps
pm2 list                            # List processes
pm2 logs insightwallet-api          # View logs
pm2 monit                           # Monitor resources
pm2 restart insightwallet-api       # Restart
pm2 reload insightwallet-api        # Zero-downtime reload
pm2 stop insightwallet-api          # Stop
pm2 delete insightwallet-api        # Remove from PM2
pm2 startup                         # Generate init script for auto-start
pm2 save                            # Save process list for resurrection
```

### Auto-start on Reboot

```bash
pm2 startup systemd     # Generate systemd service
pm2 save                # Save current process list
```

---

## Environment Variables for Production

```bash
NODE_ENV=production
PORT=5000

# MongoDB — use a dedicated Atlas cluster or production replica set
MONGODB_URI=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/insightwallet

# JWT — use strong, unique secrets (64+ hex chars)
JWT_SECRET=<random-64-hex>
JWT_REFRESH_SECRET=<different-random-64-hex>
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# Cloudinary
CLOUDINARY_CLOUD_NAME=<your-cloud-name>
CLOUDINARY_API_KEY=<your-api-key>
CLOUDINARY_API_SECRET=<your-api-secret>

# SMTP for password reset emails
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=noreply@insightwallet.com
SMTP_PASS=<app-password>

# Frontend URL for CORS and password reset links
FRONTEND_URL=https://app.insightwallet.com
```

---

## MongoDB Atlas Production Settings

### Cluster Configuration

| Setting            | Recommendation                          |
|--------------------|-----------------------------------------|
| Tier               | M10 or higher (production)             |
| Region             | Closest to your users + server          |
| Backup             | Enable continuous backup (PITR)         |
| Security           | IP whitelist only your server IP(s)     |
| Auth               | Database user with strong password      |
| TLS                | Enabled by default (Atlas)              |

### Connection String

```
MONGODB_URI=mongodb+srv://user:pass@cluster0.xxxxx.mongodb.net/insightwallet?retryWrites=true&w=majority
```

- `retryWrites=true` — Auto-retry on transient network errors
- `w=majority` — Wait for write acknowledgement from primary

### Indexes

The application creates indexes via Mongoose schemas. Verify indexes are applied after initial sync:

```bash
# Via mongosh
use insightwallet
db.transactions.getIndexes()
db.users.getIndexes()
db.budgets.getIndexes()
```

---

## Security Checklist

- [ ] JWT secrets are strong random values (64+ hex chars), unique per environment
- [ ] JWT refresh secret is different from access token secret
- [ ] MongoDB Atlas IP whitelist is restricted to server IP(s) only
- [ ] Database user password is strong (20+ chars, mixed)
- [ ] CORS origin is set to the exact frontend URL (not `*`)
- [ ] Helmet middleware is enabled (CSP, HSTS, X-Frame-Options, etc.)
- [ ] Rate limiting is active (100 general, 5 auth per 15 min)
- [ ] `NODE_ENV=production` is set (disables debug logging, error details)
- [ ] File upload limits are configured (max 5 MB, image types only)
- [ ] Input validation is active on all mutation endpoints
- [ ] `cookie-parser` secure flag is considered if using cookies
- [ ] HTTP/2 or HTTPS is enforced via reverse proxy
- [ ] PM2 process limit and memory limits are configured
- [ ] Logs are rotated (use `pm2-logrotate` or external log management)
- [ ] Secrets never committed to version control
- [ ] `.env` is in `.gitignore`

---

## Nginx Reverse Proxy Configuration

Place this in `/etc/nginx/sites-available/insightwallet-api`:

```nginx
upstream insightwallet_api {
    server 127.0.0.1:5000;
    keepalive 64;
}

server {
    listen 80;
    server_name api.insightwallet.com;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.insightwallet.com;

    # SSL certificates (use Let's Encrypt / Certbot)
    ssl_certificate     /etc/letsencrypt/live/api.insightwallet.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.insightwallet.com/privkey.pem;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Remove server version
    server_tokens off;

    # Max request size (for avatar uploads)
    client_max_body_size 10M;

    # Gzip
    gzip on;
    gzip_types application/json application/javascript text/css text/plain;
    gzip_min_length 1000;

    location / {
        proxy_pass http://insightwallet_api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
    }

    # Health check — no caching
    location /api/v1/health {
        proxy_pass http://insightwallet_api;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        add_header Cache-Control "no-store";
    }

    # Deny access to dotfiles
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    access_log /var/log/nginx/insightwallet-api-access.log;
    error_log  /var/log/nginx/insightwallet-api-error.log;
}
```

### Enable the Site

```bash
sudo ln -s /etc/nginx/sites-available/insightwallet-api /etc/nginx/sites-enabled/
sudo nginx -t              # Test configuration
sudo systemctl reload nginx  # Apply changes
```

### Let's Encrypt SSL

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.insightwallet.com
sudo certbot renew --dry-run   # Test auto-renewal
```

---

## Monitoring

### Health Check

The API exposes `/api/v1/health` returning server uptime. Configure your monitoring tool (UptimeRobot, Pingdom, etc.) to hit this endpoint.

### Log Management

Install `pm2-logrotate` for log rotation:

```bash
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 50M
pm2 set pm2-logrotate:retain 7
pm2 set pm2-logrotate:compress true
```

### Application Performance Monitoring

Consider adding:

- **Sentry** — Error tracking and performance monitoring
- **New Relic** or **Datadog** — APM and infrastructure monitoring
- **Winston** or **Pino** — Structured logging to replace `morgan` in production

---

## Deployment Checklist

- [ ] Backend build: `npm ci --omit=dev`
- [ ] Frontend build: `flutter build apk --release` (or appbundle)
- [ ] Environment variables configured for production
- [ ] PM2 process running and auto-restart configured
- [ ] Nginx reverse proxy configured with SSL
- [ ] MongoDB Atlas IP whitelist restricted
- [ ] CORS set to production frontend URL
- [ ] API health check responding correctly
- [ ] Swagger UI accessible (or disabled in production)
- [ ] Logging and monitoring configured
- [ ] Backup strategy in place (MongoDB Atlas PITR)
- [ ] Database indexes verified
