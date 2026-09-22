# Roteiro didático — Terraform no laboratório AWS

## Objetivos de aprendizagem

Ao final, o aluno deverá conseguir explicar e executar:

1. diferença entre **root module** e **child module**;
2. separação de ambientes DEV e PRD;
3. state remoto e locking;
4. uso de variáveis, locals e outputs;
5. IAM por responsabilidade;
6. empacotamento e deployment de Lambda;
7. EventBridge Scheduler chamando Lambda;
8. S3 como camada RAW;
9. Glue Crawler + Glue Data Catalog;
10. Athena Workgroup;
11. CloudWatch Logs e Alarm;
12. `plan`, `apply`, inspeção, falha proposital e `destroy`.

## Mapa: material original x Terraform

| Material | Terraform |
|---|---|
| Criar bucket S3 | `modules/data_lake` |
| Lambda Python | `modules/lambda_ingestion` |
| Variáveis de ambiente | `environment.variables` da Lambda |
| Execution Role / S3 PutObject | policy do módulo Lambda |
| CloudWatch Logs | log group explícito no módulo Lambda |
| EventBridge Scheduler | `modules/scheduler` |
| Glue Crawler / Catalog | `modules/glue_catalog` |
| Athena | `modules/athena` |
| Observabilidade de erros | `modules/observability` |
| Power BI | etapa externa, após Athena |

## Fluxo recomendado da aula

### 1. Conceito

Explique primeiro:

```text
Root module (DEV/PRD)
        |
        +--> child modules
        |
        +--> variáveis específicas do ambiente
        |
        +--> state específico do ambiente
```

### 2. Criar

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### 3. Inspecionar

```bash
terraform state list
terraform output
aws lambda get-function --function-name "$(terraform output -raw lambda_function_name)"
aws s3api get-public-access-block --bucket "$(terraform output -raw raw_bucket_name)"
aws scheduler get-schedule --name "$(terraform output -raw scheduler_name)" --group-name "$(terraform output -raw scheduler_name)-group"
```

### 4. Testar

```bash
aws lambda invoke \
  --function-name "$(terraform output -raw lambda_function_name)" \
  --payload '{}' \
  response.json

cat response.json
aws s3 ls "s3://$(terraform output -raw raw_bucket_name)/raw/" --recursive
```

### 5. Quebrar propositalmente

Altere temporariamente a URL de `pedidos` para uma URL inválida:

```hcl
pedidos = "https://exemplo-invalido/pedidos.csv"
```

Depois:

```bash
terraform apply
aws lambda invoke \
  --function-name "$(terraform output -raw lambda_function_name)" \
  --payload '{}' \
  response.json
```

A Lambda deve falhar porque a versão do laboratório lança exceção se qualquer arquivo falhar.

### 6. Troubleshooting

```bash
aws logs tail "/aws/lambda/$(terraform output -raw lambda_function_name)" --since 10m
```

Verifique também o alarme:

```bash
aws cloudwatch describe-alarms \
  --alarm-names "$(terraform output -raw cloudwatch_alarm_name)"
```

### 7. Corrigir

Restaure a URL correta e reaplique:

```bash
terraform plan
terraform apply
```

Execute novamente a Lambda e confirme os quatro objetos em S3.

### 8. Glue

```bash
aws glue start-crawler --name "$(terraform output -raw glue_crawler_name)"
aws glue get-crawler --name "$(terraform output -raw glue_crawler_name)"
```

Depois liste as tabelas:

```bash
aws glue get-tables \
  --database-name "$(terraform output -raw glue_database_name)" \
  --query 'TableList[].Name'
```

### 9. Athena

Use o workgroup retornado pelo Terraform e execute `SHOW TABLES;` no database catalogado.

### 10. Questões para discussão

- Por que a Lambda recebe apenas `s3:PutObject` em `raw/*`?
- Por que DEV e PRD têm states separados?
- Por que o schedule de DEV começa desabilitado?
- Qual o risco de `force_destroy = true` em PRD?
- Por que `source_code_hash` é importante?
- Por que URLs são variáveis e não ficam hardcoded no Python?
- O que muda se a Lambda for colocada em uma VPC privada?
- Qual a diferença entre a role da Lambda, a role do Scheduler e a role do Glue Crawler?

### 11. Cleanup

```bash
terraform destroy
```

Em PRD, a destruição do bucket falha se ainda houver objetos, propositalmente, porque `force_destroy = false`.
