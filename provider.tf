terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.63.0"
    }
  }

  backend "s3" {
    bucket = "markemining-terraform"
    key = "state"
    region = "us-east-1"
  }
}

provider "aws" {

}
