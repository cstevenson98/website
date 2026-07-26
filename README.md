# Personal website

A static website hosted on Google Cloud: content lives in a **Cloud Storage**
bucket, served publicly through an **external HTTPS load balancer** with
**Cloud CDN** and a Google-managed TLS certificate. Infrastructure is defined
with **Terraform**; secrets/config are injected with **Doppler**.

No backend, no build step yet — just static files in `site/`.

## Layout

```
.
├── .github/workflows/  # GitHub Actions (manual deploy on main)
├── dev                 # management script (serve / terraform / deploy)
├── site/               # static site content (deployed to the bucket)
│   ├── index.html
│   └── 404.html
├── terraform/          # infrastructure (bucket, LB, CDN, TLS)
└── .env.example        # documents the env vars Doppler must provide
```

## Prerequisites

- [Doppler CLI](https://docs.doppler.com/docs/install-cli)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (`gcloud`)
- `python3` (only for `./dev serve`)

## One-time setup

1. **Create a GCP service account** with roles to manage the resources
   (e.g. `roles/storage.admin` and `roles/compute.admin`), and download a JSON key.

2. **Configure Doppler.** Link this repo to a Doppler project/config and add the
   secrets listed in `.env.example`:

   ```bash
   doppler setup
   # then set each secret, e.g.:
   doppler secrets set GOOGLE_PROJECT GOOGLE_REGION TF_STATE_BUCKET BUCKET_NAME ...
   ```

   Paste the service-account JSON as the `GOOGLE_CREDENTIALS` secret.

   Doppler secret names are UPPERCASE; the `dev` script maps them to the
   lowercase `TF_VAR_*` variables Terraform expects (see `.env.example`).

3. **Create the Terraform state bucket:**

   ```bash
   ./dev bootstrap
   ```

## Deploy

```bash
./dev init          # terraform init (backend configured from env)
./dev plan          # review changes
./dev apply         # create the bucket (+ LB/CDN/TLS if DOMAIN_NAME set)
./dev deploy        # upload site/ to the bucket and invalidate the CDN
```

If you set `DOMAIN_NAME`, point your DNS **A record** at the load balancer
IP (`./dev outputs` shows `load_balancer_ip`). The managed certificate becomes
active a few minutes to a few hours after DNS resolves.

Before a domain is configured, the site is reachable at the `bucket_public_url`
output.

## GitHub Actions (manual deploy)

A **Deploy** workflow runs only from `main` via the Actions UI button
(`workflow_dispatch`). It uses Doppler for secrets — the same path as local.

One-time setup:

1. In Doppler → project `website` → config `dev` (or `prd`), create a
   **Service Token**.
2. In GitHub → repo → Settings → Secrets and variables → Actions, add
   `DOPPLER_TOKEN` with that token value.
3. Push to `main`, then: **Actions → Deploy → Run workflow**.

The job installs Doppler + gcloud and runs `./dev deploy`.

## Local preview

```bash
./dev serve         # http://localhost:8000
```

## Common commands

Run `./dev help` for the full list. Everything that touches GCP runs under
`doppler run --`, so secrets never live on disk.
