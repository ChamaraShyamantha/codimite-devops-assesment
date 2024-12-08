# Define the GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name                     = var.gke_cluster_name
  location                 = "us-central1-a" # Changed to a single zone to reduce SSD quota usage
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.subnets[0].self_link
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  # Enable IP Allocation for Pods and Services
  ip_allocation_policy {}
}

# Define the General Node Pool
resource "google_container_node_pool" "general_pool" {
  name       = "general-pool"
  cluster    = google_container_cluster.gke_cluster.id
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 30 
    preemptible  = true

    tags = ["no-external-ip"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# Define the CPU-Intensive Node Pool
resource "google_container_node_pool" "cpu_intensive_pool" {
  name       = "cpu-intensive-pool"
  cluster    = google_container_cluster.gke_cluster.id
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 30 

    tags = ["no-external-ip"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
