provider "google" {
  region = var.region
}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = "10.0.0.0/24"
  network                  = google_compute_network.default.self_link
  region                   = var.region
 
}

data "google_client_config" "current" {
}

data "google_container_engine_versions" "default" {
  location = var.location
}

resource "google_container_cluster" "default" {
  name               = var.cluster_name
  location           = var.location
  initial_node_count = 3
  min_master_version = data.google_container_engine_versions.default.latest_master_version
  network            = google_compute_network.default.name
  subnetwork         = google_compute_subnetwork.default.name

  enable_legacy_abac = true
  node_config {
    machine_type = "e2-standard-2"
  }
provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.default.name} --zone ${google_container_cluster.default.location} --project ${var.project}"
  }

}
