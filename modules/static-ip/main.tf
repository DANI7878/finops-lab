resource "google_compute_address" "this" {
  name         = var.name
  region       = var.region
  address_type = "EXTERNAL"
  labels       = var.labels
}
