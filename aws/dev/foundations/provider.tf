terraform {
  required_version = "~> 1.0.3"
  required_providers {
      databricks = {
          source = "databrickslabs/databricks"
          version = "0.3.11"
      }
  }

  backend "remote" {}
}

provider "aws" {
    region = var.region
}