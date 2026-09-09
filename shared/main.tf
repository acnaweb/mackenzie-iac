terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.63.0"
    }
  }
}

provider "aws" {
  # Configuration options
}


resource "aws_s3_bucket" "bucket1" {
  bucket = "marketmining-bucket1"
}

resource "aws_s3_bucket" "web" {
  bucket = "marketmining-static-pages"
}


resource "aws_s3_bucket" "images" {
  bucket = "marketmining-images"
}