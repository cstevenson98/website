output "website_bucket" {
  description = "Name of the GCS bucket holding the site content."
  value       = google_storage_bucket.site.name
}

output "bucket_public_url" {
  description = "Direct GCS URL of the index page (useful before DNS is set up)."
  value       = "https://storage.googleapis.com/${google_storage_bucket.site.name}/${var.index_page}"
}

output "load_balancer_ip" {
  description = "Global anycast IP to point your DNS A record at."
  value       = local.enable_lb ? google_compute_global_address.default[0].address : null
}

output "url_map_name" {
  description = "URL map name, used to invalidate the CDN cache on deploy."
  value       = local.enable_lb ? google_compute_url_map.default[0].name : null
}

output "domain" {
  description = "Configured custom domain, if any."
  value       = local.enable_lb ? var.domain_name : null
}
