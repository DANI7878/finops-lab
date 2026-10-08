output "id" {
  description = "Disk ID."
  value       = google_compute_disk.this.id
}

output "name" {
  description = "Disk name."
  value       = google_compute_disk.this.name
}

output "self_link" {
  description = "Disk self link, used when attaching the disk to a VM."
  value       = google_compute_disk.this.self_link
}

output "snapshot_name" {
  description = "Snapshot name, or null when no snapshot was created."
  value       = try(google_compute_snapshot.this[0].name, null)
}
