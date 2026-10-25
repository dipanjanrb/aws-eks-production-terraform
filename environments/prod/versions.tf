terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # In production, configure an S3 remote state bucket with DynamoDB state locking:
  # backend "s3" {
  #   bucket         = "company-prod-terraform-state-us-east-1"
  #   key            = "eks/prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "Core-Platform"
      Owner       = "DevOps-Team"
    }
  }
}
