terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  # Backend is configured at `terraform init` time via -backend-config flags
  # (see the `dev` script), so nothing is hard-coded here.
  backend "gcs" {}
}
