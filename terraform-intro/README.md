# mackenzie-iac

* Criar imagem 

```sh 
docker build -t iac .
```

* Executar container

```sh 
docker run -it -v ./shared:/shared iac

docker run -it -v .:/shared iac
```

terraform init
terraform init -backend-config=dev/backend.hcl
terraform init -backend-config=prd/backend.hcl

terraform plan

terraform plan --target=module.storage
terraform plan --target=module.storage -var-file=dev/terraform.tfvars  
terraform plan --target=module.storage -var-file=prd/terraform.tfvars  


terraform apply

terraform apply --target=module.compute -var-file=environments/prd.tfvars  

terraform import aws_s3_bucket.repetido mba-cloud-sre-mm-mackenzie

aws configure

aws sts get-caller-identity





## Referencias

- https://developer.hashicorp.com/terraform


- https://developer.hashicorp.com/terraform/language/backend

- https://developer.hashicorp.com/terraform/language/modules/develop/structure

https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html