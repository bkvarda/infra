terraform {
  required_version = "~> 1.0.3"

  backend "remote" {}
}

provider "aws" {
    region = var.region
}