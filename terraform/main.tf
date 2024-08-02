terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region  = "us-east-1"
  profile = "dev"
}

terraform {
 backend "s3" {
   bucket         = "tf-state-cdec-26-27-28"
   key            = "state/terraform.tfstate"
   region         = "us-east-1"
 }
}