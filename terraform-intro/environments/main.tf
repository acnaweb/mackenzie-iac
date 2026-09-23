module "storage" {
  source = "../modules/storage"  
  nome_bucket = var.nome_bucket
}

module "lambda" {
  source = "../modules/lambda"
}

module "compute" {
  source = "../modules/compute"
}