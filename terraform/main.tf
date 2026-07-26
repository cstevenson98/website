locals {
  # Only stand up the HTTPS load balancer + CDN stack when a domain is provided.
  enable_lb = var.domain_name != ""
}

# ---------------------------------------------------------------------------
# Website content bucket
# ---------------------------------------------------------------------------
resource "google_storage_bucket" "site" {
  name                        = var.bucket_name
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = var.index_page
    not_found_page   = var.not_found_page
  }
}

# Make objects world-readable so they can be served publicly.
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# ---------------------------------------------------------------------------
# External HTTPS load balancer + Cloud CDN (only when domain_name is set)
# ---------------------------------------------------------------------------
resource "google_compute_global_address" "default" {
  count = local.enable_lb ? 1 : 0
  name  = "${var.bucket_name}-ip"
}

resource "google_compute_backend_bucket" "default" {
  count       = local.enable_lb ? 1 : 0
  name        = "${var.bucket_name}-backend"
  bucket_name = google_storage_bucket.site.name
  enable_cdn  = true

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  count = local.enable_lb ? 1 : 0
  name  = "${var.bucket_name}-cert"

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_url_map" "default" {
  count           = local.enable_lb ? 1 : 0
  name            = "${var.bucket_name}-urlmap"
  default_service = google_compute_backend_bucket.default[0].id
}

resource "google_compute_target_https_proxy" "default" {
  count            = local.enable_lb ? 1 : 0
  name             = "${var.bucket_name}-https-proxy"
  url_map          = google_compute_url_map.default[0].id
  ssl_certificates = [google_compute_managed_ssl_certificate.default[0].id]
}

resource "google_compute_global_forwarding_rule" "https" {
  count                 = local.enable_lb ? 1 : 0
  name                  = "${var.bucket_name}-https"
  target                = google_compute_target_https_proxy.default[0].id
  ip_address            = google_compute_global_address.default[0].address
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

# Redirect all plain HTTP traffic to HTTPS.
resource "google_compute_url_map" "https_redirect" {
  count = local.enable_lb ? 1 : 0
  name  = "${var.bucket_name}-http-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "http" {
  count   = local.enable_lb ? 1 : 0
  name    = "${var.bucket_name}-http-proxy"
  url_map = google_compute_url_map.https_redirect[0].id
}

resource "google_compute_global_forwarding_rule" "http" {
  count                 = local.enable_lb ? 1 : 0
  name                  = "${var.bucket_name}-http"
  target                = google_compute_target_http_proxy.http[0].id
  ip_address            = google_compute_global_address.default[0].address
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
