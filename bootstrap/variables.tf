variable "aws_region" {
  description = "Região AWS usada no laboratório."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome curto do projeto."
  type        = string
  default     = "mba-cloud-sre"
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}
