module "storage" {
  source = "./modules/storage"
}

module "lambda" {
  source = "./modules/lambda"
}

module "compute" {
  source = "./modules/compute"
}