terraform {
  backend "gcs" {
    bucket = "code-bucket-codimite"
    prefix = "terraform/state"
  }
}

resource "google_storage_bucket" "state_bucket" {
  name     = var.state_bucket_name
  location = var.region
  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }
}
