# Credentials are supplied via the GOOGLE_CREDENTIALS env var (service-account
# JSON), injected by Doppler. project/region come from TF_VAR_* env vars.
provider "google" {
  project = var.project_id
  region  = var.region
}
