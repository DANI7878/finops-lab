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
# Central bucket used for GCS access logs.
# ---------------------------------------------------------------------------

# checkov:skip=CKV_GCP_62:Dedicated access logging destination bucket; logging it to itself would create recursive logging
resource "google_storage_bucket" "access_logs" {
  name          = "${var.project_id}-${var.name_prefix}access-logs"
  location      = upper(var.region)
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  labels = merge(
    local.base_labels,
    {
      purpose = "access-logs"
    }
  )
}

# Google-managed Cloud Storage service account used for log delivery.
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_storage_bucket_iam_member" "access_log_writer" {
  bucket = google_storage_bucket.access_logs.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

# ---------------------------------------------------------------------------
# Deliberate waste.
# Each resource maps to one detector we will build later.
# ---------------------------------------------------------------------------

# Waste 1: a VM that runs and does nothing.
module "idle_vm" {
  source = "../../modules/compute-vm"

  name         = "${var.name_prefix}idle-vm-01"
  zone         = var.zone
  machine_type = "e2-micro"

  # The idle VM does not require a public IP.
  enable_external_ip = false

  labels = merge(
    local.base_labels,
    {
      waste_type = "idle-vm"
    }
  )
}

# Waste 2 and 3:
# A disk attached to nothing, plus a snapshot nobody needs.
module "orphan_disk" {
  source = "../../modules/persistent-disk"

  name            = "${var.name_prefix}orphan-disk-01"
  zone            = var.zone
  size_gb         = 10
  create_snapshot = true
  snapshot_name   = "${var.name_prefix}orphan-snapshot-01"

  labels = merge(
    local.base_labels,
    {
      waste_type = "unattached-disk"
    }
  )
}

# Waste 4:
# A reserved static IP attached to nothing.
module "unused_ip" {
  source = "../../modules/static-ip"

  name   = "${var.name_prefix}unused-ip-01"
  region = var.region

  labels = merge(
    local.base_labels,
    {
      waste_type = "unused-ip"
    }
  )
}

# Waste 5:
# Versioning is enabled but there are intentionally no lifecycle rules.
# Old object versions can therefore accumulate and create unnecessary cost.
module "no_lifecycle_bucket" {
  source = "../../modules/storage-bucket"

  name          = "${var.project_id}-${var.name_prefix}lab-data"
  location      = upper(var.region)
  force_destroy = true

  versioning_enabled = true

  logging_bucket    = google_storage_bucket.access_logs.name
  log_object_prefix = "no-lifecycle/"

  labels = merge(
    local.base_labels,
    {
      waste_type = "no-lifecycle"
    }
  )

  depends_on = [
    google_storage_bucket_iam_member.access_log_writer
  ]
}

# ---------------------------------------------------------------------------
# Control:
# A healthy resource. A good detector must NOT flag this resource.
# ---------------------------------------------------------------------------

module "control_bucket" {
  source = "../../modules/storage-bucket"

  name          = "${var.project_id}-${var.name_prefix}lab-archive"
  location      = upper(var.region)
  force_destroy = true

  versioning_enabled = true

  logging_bucket    = google_storage_bucket.access_logs.name
  log_object_prefix = "control/"

  labels = merge(
    local.base_labels,
    {
      waste_type = "none"
      control    = "true"
    }
  )

  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }

      condition = {
        age = 30
      }
    },
    {
      action = {
        type = "Delete"
      }

      condition = {
        age = 365
      }
    },
  ]

  depends_on = [
    google_storage_bucket_iam_member.access_log_writer
  ]
}