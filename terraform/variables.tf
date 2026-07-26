variable "project_id" {
  type        = string
  description = "GCP project ID (set via TF_VAR_project_id)."
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "Region for the website storage bucket (set via TF_VAR_region)."
}

variable "bucket_name" {
  type        = string
  description = "Globally-unique GCS bucket name that holds the website content."
}

variable "domain_name" {
  type        = string
  default     = ""
  description = <<-EOT
    Custom domain for the site (e.g. "www.example.com"). When set, an external
    HTTPS load balancer with Cloud CDN and a Google-managed SSL certificate is
    created. When empty, only the public storage bucket is provisioned.
  EOT
}

variable "index_page" {
  type        = string
  default     = "index.html"
  description = "Object served for the site root."
}

variable "not_found_page" {
  type        = string
  default     = "404.html"
  description = "Object served for missing paths."
}
