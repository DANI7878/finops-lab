output "id" {
  description = "Instance ID."
  value       = google_compute_instance.this.id
}

output "name" {
  description = "Instance name."
  value       = google_compute_instance.this.name
}

output "self_link" {
  description = "Instance self link."
  value       = google_compute_instance.this.self_link
}

output "zone" {
  description = "Zone the instance runs in."
  value       = google_compute_instance.this.zone
}

output "machine_type" {
  description = "Machine type."
  value       = google_compute_instance.this.machine_type
}

output "internal_ip" {
  description = "Internal IP address."
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address, or null when none is attached."
  value       = try(google_compute_instance.this.network_interface[0].access_config[0].nat_ip, null)
}
