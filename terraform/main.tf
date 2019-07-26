provider "azurerm" {
  version = "=1.31.0"
}

provider "local" {
  version = "=1.3.0"
}

variable "location" {
  default = "UK South"
}

terraform {
  backend "azurerm" {}
}

variable "env" {}
variable "app_gw_private_ip_address" {}

module "app-gw" {
  source    = "./app-gateway-module"
  yaml_path = "${path.cwd}/../team-config/${var.env}/all.yaml"
  env       = var.env

  location           = var.location
  private_ip_address = var.app_gw_private_ip_address
}
