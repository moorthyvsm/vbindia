# 🇮🇳 India Visa Bulletin Tracker

A clean, dark-themed web dashboard that tracks **US Employment-Based Visa Bulletin** priority dates for **India — EB-1, EB-2, and EB-3** categories over the last 2 years.

Displays both **Final Action Dates (Table A)** and **Dates for Filing (Table B)** with an interactive chart and full monthly data table.

![India Visa Bulletin Tracker](https://img.shields.io/badge/Data-travel.state.gov-blue) ![Static](https://img.shields.io/badge/Type-Static%20HTML-green) ![Docker](https://img.shields.io/badge/Docker-nginx%3Aalpine-2496ED?logo=docker&logoColor=white)

---

## Features

- 📊 **Interactive line chart** — toggle between Final Action Dates and Dates for Filing
- 🗂️ **Monthly data table** — all 26 months with both Table A & Table B side by side
- 📋 **Stat cards** — latest priority date + estimated wait time for each category
- ✅ **Verified data** — fetched directly from official [travel.state.gov](https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin.html) bulletin pages
- 🌑 **Dark theme** — easy on the eyes, no dependencies except Chart.js (CDN)

---

## Setup

This is a **zero-build, single-file** static web app. No npm, no frameworks, no compilation.

### Option 1 — Open directly in browser (simplest)

```bash
git clone https://github.com/moorthyvsm/vbindia.git
cd vbindia
open index.html          # macOS
# xdg-open index.html   # Linux
# start index.html      # Windows
```

> Works as a `file://` URL. Chart.js is loaded from CDN so you need internet access on first load.

---

### Option 2 — Run a local server (recommended)

A `serve.py` helper is included that starts a simple HTTP server on port **3456**.

**Requirements:** Python 3 (pre-installed on macOS and most Linux distros)

```bash
git clone https://github.com/moorthyvsm/vbindia.git
cd vbindia
python3 serve.py
```

Then open: **http://localhost:3456**

---

### Option 3 — Any static file server

Since `index.html` is fully self-contained, you can use any static server:

```bash
# Using Python (built-in, manual chdir)
cd vbindia && python3 -m http.server 8080

# Using Node.js / npx
npx serve .

# Using Ruby (built-in)
ruby -run -e httpd . -p 8080

# Using PHP
php -S localhost:8080
```

---

### Option 4 — Docker 🐳

**Requirements:** [Docker](https://docs.docker.com/get-docker/) (Desktop or Engine)

The image is built on `nginx:alpine` (~8 MB) and serves on port **8080**.

#### Quick start

```bash
git clone https://github.com/moorthyvsm/vbindia.git
cd vbindia

# Build and run
docker build -t vbindia .
docker run -d -p 8080:8080 --name vbindia vbindia
```

Then open: **http://localhost:8080**

#### Using Docker Compose (recommended)

```bash
docker compose up -d          # build + start in background
docker compose down           # stop and remove
docker compose up -d --build  # rebuild after updating index.html
```

#### Useful commands

```bash
docker logs vbindia           # view nginx access logs
docker stats vbindia          # memory / CPU usage
docker exec -it vbindia sh    # shell into the container
```

#### Run on a different port

```bash
docker run -d -p 3000:8080 --name vbindia vbindia
# Now accessible at http://localhost:3000
```

#### Deploy to a VPS / cloud

```bash
# Build and tag for a registry
docker build -t ghcr.io/<your-user>/vbindia:latest .
docker push ghcr.io/<your-user>/vbindia:latest

# Pull and run on your server
docker pull ghcr.io/<your-user>/vbindia:latest
docker run -d -p 80:8080 --restart unless-stopped --name vbindia \
  ghcr.io/<your-user>/vbindia:latest
```

> The container runs nginx as a **non-root user** and includes a health check.

---

### Option 5 — Deploy to a server / VPS (without Docker)

Upload just `index.html` (and optionally `serve.py`) to any server and serve it with Nginx, Apache, or Caddy — it's a single HTML file.

**Nginx example:**

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    root /var/www/vbindia;
    index index.html;
}
```

**GitHub Pages / Netlify / Vercel:**

Push the repo to GitHub and enable GitHub Pages (`Settings → Pages → Deploy from branch → main`). No build step needed.

> For containerized cloud deployments (AWS ECS, GCP Cloud Run, Railway, Fly.io), use the Docker option above.

---

## Data

All dates are sourced from the official **US Department of State Visa Bulletins**:

| Table | Description |
|-------|-------------|
| **Table A — Final Action Dates** | Visa can be issued if your priority date is **earlier** than this date |
| **Table B — Dates for Filing** | You may file your I-485 if USCIS authorizes use of this chart that month |

Data covers **March 2024 – April 2026** (26 months), India-born employment-based categories:

| Category | Description |
|----------|-------------|
| **EB-1** | Priority Workers (extraordinary ability, outstanding researchers, multinational managers) |
| **EB-2** | Advanced Degree professionals or Exceptional Ability |
| **EB-3** | Skilled Workers, professionals, and other workers |

---

## Updating Data

When a new visa bulletin is published (~15th of each month), add a new row to the `bulletinData` array in `index.html`:

```js
{ m:"May 2026", eb1:"YYYY-MM-DD", eb2:"YYYY-MM-DD", eb3:"YYYY-MM-DD",
                d1:"YYYY-MM-DD",  d2:"YYYY-MM-DD",  d3:"YYYY-MM-DD" },
```

- `eb1/eb2/eb3` → Final Action Dates (Table A), India row, columns 1st/2nd/3rd
- `d1/d2/d3`   → Dates for Filing (Table B), India row, columns 1st/2nd/3rd

Official source: [travel.state.gov/visa-bulletin](https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin.html)

---

## Tech Stack

| Component | Tech |
|-----------|------|
| Markup & Logic | Vanilla HTML + JavaScript (ES6) |
| Charts | [Chart.js 4.4](https://www.chartjs.org/) via CDN |
| Styles | Plain CSS (no framework) |
| Server (optional) | Python 3 `http.server` |
| Container | nginx:alpine via Docker |

---

## License

MIT — free to use, modify, and share.
