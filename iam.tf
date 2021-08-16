module "iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 5.0"

  projects = [var.project_id]

  bindings = {
    "roles/storage.admin" = [
      "serviceAccount:${google_service_account.gke_sva.email}",
    ]
    "roles/cloudsql.client" = [
      "serviceAccount:${google_service_account.gke_sva.email}",
    ]
    
  }
}