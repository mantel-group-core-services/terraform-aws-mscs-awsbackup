terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

locals {
  enforced_tags = {
    Owner       = "MantelGroupManagedServices"
    CoreService = "AWSBackup"
  }
}
