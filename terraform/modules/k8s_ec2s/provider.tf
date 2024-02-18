terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

provider "aws" {
  region  = var.region
}

provider "cloudinit" {
}