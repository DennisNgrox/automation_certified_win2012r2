terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

variable "acme_record_name" {
  description = "Nome completo do registro ACME para validação DNS"
  type        = string
}

variable "acme_token" {
  description = "Valor do token ACME para validação DNS"
  type        = string
}

resource "aws_route53_record" "acme_challenge" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.acme_record_name
  type    = "TXT"
  ttl     = 300
  records = ["\"${var.acme_token}\""]
}

# Executar
# terraform apply -var="acme_record_name=$dns_record" -var="acme_token=$token"
