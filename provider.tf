# Version constraints
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.52.0"
    }
  }
}



# Configure the AWS Provider
provider "aws" {
  region = var.aws_account_region
}
