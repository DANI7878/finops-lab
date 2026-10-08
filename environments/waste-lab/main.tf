locals {
  base_labels = merge(
    {
      project = "finops-lab"
      purpose = "waste-lab"
      managed = "terraform"
      env     = "dev"
    },
    var.extra_labels,
  )
}

# ---------------------------------------------------------------------------
# Deliberate waste. Each resource maps to one detector we will build later.
# ---------------------------------------------------------------------------

# Waste 1: a VM that runs and does nothing.
module "idle_vm" {
  source = "../../modules/compute-vm"

  name         = "${var.name_prefix}idle-vm-01"
  zone         = var.zone
  machine_type = "e2-micro"
  labels       = merge(local.base_labels, { waste_type = "idle-vm" })
}

# Waste 2 and 3: a disk attached to nothing, plus a snapshot nobody needs.
module "orphan_disk" {
  source = "../../modules/persistent-disk"

  name            = "${var.name_prefix}orphan-disk-01"
  zone            = var.zone
  size_gb         = 10
  create_snapshot = true
  snapshot_name   = "${var.name_prefix}orphan-snapshot-01"
  labels          = merge(local.base_labels, { waste_type = "unattached-disk" })
}

# Waste 4: a reserved static IP attached to nothing.
module "unused_ip" {
  source = "../../modules/static-ip"

  name   = "${var.name_prefix}unused-ip-01"
  region = var.region
  labels = merge(local.base_labels, { waste_type = "unused-ip" })
}

# Waste 5: a bucket with no lifecycle rules.
module "no_lifecycle_bucket" {
  source = "../../modules/storage-bucket"

  name          = "${var.project_id}-${var.name_prefix}lab-data"
  location      = upper(var.region)
  force_destroy = true
  labels        = merge(local.base_labels, { waste_type = "no-lifecycle" })
}

# ---------------------------------------------------------------------------
# Control: a healthy resource. A good detector must NOT flag this one.
# Controls let us measure false positives, not just detection.
# ---------------------------------------------------------------------------

module "control_bucket" {
  source = "../../modules/storage-bucket"

  name          = "${var.project_id}-${var.name_prefix}lab-archive"
  location      = upper(var.region)
  force_destroy = true
  labels        = merge(local.base_labels, { waste_type = "none", control = "true" })

  lifecycle_rules = [
    {
      action    = { type = "SetStorageClass", storage_class = "NEARLINE" }
      condition = { age = 30 }
    },
    {
      action    = { type = "Delete" }
      condition = { age = 365 }
    },
  ]
}
