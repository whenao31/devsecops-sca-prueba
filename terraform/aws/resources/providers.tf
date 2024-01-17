terraform {

  backend "s3" {
    bucket = "prueba-devsecops"
    key    = "terraform/tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}