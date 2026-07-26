# Personal website

A math-friendly personal site built with **Eleventy** (Markdown → static HTML,
**KaTeX** for math), hosted on Google Cloud Storage. Infrastructure is
**Terraform**; secrets are injected with **Doppler**.

## Layout

```
.
├── .github/workflows/  # Secrets scan + manual deploy on main
├── src/                # Eleventy content (Markdown, layouts, CSS)
│   ├── posts/          # Blog posts (.md with $...$ / $$...$$ math)
│   └── _includes/      # Nunjucks layouts
├── _site/              # Build output (gitignored; uploaded on deploy)
├── eleventy.config.js
├── package.json
├── dev                 # management script (serve / build / terraform / deploy)
├── terraform/          # bucket, optional LB/CDN/TLS
└── .env.example
```

## Prerequisites

- Node.js >= 20 and npm (see nix-config `node-support`)
- [Doppler CLI](https://docs.doppler.com/docs/install-cli)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`)

## Content

Write posts as Markdown under `src/posts/`. Use KaTeX delimiters:

- Inline: `$E = mc^2$`
- Display: `$$ ... $$`

```bash
npm install          # once
./dev serve          # live reload at http://localhost:8000
./dev build          # write _site/
```

## One-time GCP setup

1. Create a GCP service account (`roles/storage.admin`, `roles/compute.admin`) and put the JSON key in Doppler as `GOOGLE_CREDENTIALS`.
2. `doppler setup` and set secrets from `.env.example`.
3. `./dev bootstrap` → `./dev init` → `./dev apply`.

## Deploy

```bash
./dev deploy         # builds with Eleventy, syncs _site/, invalidates CDN
```

Or: **Actions → Deploy → Run workflow** on `main` (needs `DOPPLER_TOKEN` on the `production` environment).

Live URL (no custom domain yet):  
https://storage.googleapis.com/personal-website-503008-site/index.html

Deploy builds with `PATH_PREFIX=/<bucket>/` so CSS and post links work on that
path-style GCS URL. Local `./dev serve` keeps prefix `/`.

## Common commands

Run `./dev help`. GCP commands use `doppler run --`.
