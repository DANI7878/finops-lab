output "expected_findings" {
  description = "Ground truth: the waste a perfect detector would find. Feeds the golden dataset in the evals phase."
  value = [
    { resource_type = "compute_instance", name = module.idle_vm.name, waste_type = "idle-vm" },
    { resource_type = "compute_disk", name = module.orphan_disk.name, waste_type = "unattached-disk" },
    { resource_type = "compute_snapshot", name = module.orphan_disk.snapshot_name, waste_type = "old-snapshot" },
    { resource_type = "compute_address", name = module.unused_ip.name, waste_type = "unused-ip" },
    { resource_type = "storage_bucket", name = module.no_lifecycle_bucket.name, waste_type = "no-lifecycle" },
  ]
}

output "expected_non_findings" {
  description = "Ground truth: healthy resources a good detector must leave alone."
  value = [
    { resource_type = "storage_bucket", name = module.control_bucket.name },
  ]
}
