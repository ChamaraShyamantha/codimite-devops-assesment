provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  count                     = length(var.subnet_cidr_ranges)
  name                      = "${var.vpc_name}-subnet-${count.index}"
  ip_cidr_range             = var.subnet_cidr_ranges[count.index]
  network                   = google_compute_network.vpc.self_link
  region                    = var.region
}
