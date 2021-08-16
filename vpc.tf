module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~>2.1"

  project_id              = var.host_project
  network_name            = "truly-net01"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = "false"

  subnets = [
    {
      subnet_name           = "teletext-prod-nodes-sn"
      subnet_ip             = "10.20.0.0/26"
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"

    },
  ]
  secondary_ranges = {

    teletext-prod-nodes-sn = [
      {
        range_name    = "teletext-prod-pods-sn"
        ip_cidr_range = "10.21.0.0/18"
      },
      {
        range_name    = "teletext-prod-services-sn"
        ip_cidr_range = "10.25.0.0/24"
      },
    ]
  }
}
