# GKE Cluster ###############################
resource "google_container_cluster" "primary" {
  name               = "teletext-prod-gke-01"
  provider           = google-beta
  location           = var.region
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  min_master_version = "1.16.13-gke.401"
  network            = var.network
  subnetwork         = var.subnet_2
  node_locations     = var.zones
  ip_allocation_policy {
    cluster_secondary_range_name  = "teletext-prod-pods-sn"
    services_secondary_range_name = "teletext-prod-services-sn"
  }

  network_policy {
    provider = "CALICO"
    enabled  = true
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.32/28"
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "00:00"
    }
  }


  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

# App NodePool ########################
resource "google_container_node_pool" "prod_app_nodepool" {
  name       = "prod-app-nodepool"
  provider   = google-beta
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible     = true
    machine_type    = "n1-standard-4"
    disk_size_gb    = 30
    disk_type       = "pd-standard"
    image_type      = "COS"
    service_account = google_service_account.gke_sva.email
    tags            = ["iap-ssh"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

}

# Elasticsearch NodePool ########################
resource "google_container_node_pool" "prod_elasticsearch_nodepool" {
  name       = "prod-elasticsearch-nodepool"
  provider   = google-beta
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible     = true
    machine_type    = "n1-standard-8"
    disk_size_gb    = 30
    disk_type       = "pd-standard"
    image_type      = "COS"
    service_account = google_service_account.gke_sva.email
    tags            = ["iap-ssh"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

}