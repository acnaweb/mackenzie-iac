resource "aws_s3_bucket" "dinanico" {
  bucket = var.nome_bucket
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


resource "aws_s3_bucket" "mba" {
  bucket = "marketmining-mba"
}

resource "aws_s3_bucket" "repetido" {
  bucket = "mba-cloud-sre-mm-mackenzie"
}

resource "aws_s3_bucket" "bucket" {
  count = 30
  # ------
  bucket = "marketmining-${count.index + 1}"
}