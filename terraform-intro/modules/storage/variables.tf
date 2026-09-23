variable "nome_bucket" {
    description = "Nome do bucket"
    type = string  
    default = "bucket-com-default"
}

variable "var2" {
    description = "Variavel 2"
    type = bool    
    default = false  
}

variable "env" {
    description = "Environments (dev/hmg/prd)"
    type = string
    default = "dev"  
}