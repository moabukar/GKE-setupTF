resource "google_service_account" "gke_sva" {
  account_id   = "gke-sva"
  display_name = "GKE service account"
}