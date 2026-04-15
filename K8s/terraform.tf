terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "/home/nasg0725/Devops/Terraform/K8s/rancher.config"
  }
}
