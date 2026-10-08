output "id" {
  description = "Address ID."
  value       = google_compute_address.this.id
}

output "name" {
  description = "Address name."
  value       = google_compute_address.this.name
}

output "address" {
  description = "The reserved IP address."
  value       = google_compute_address.this.address
}
