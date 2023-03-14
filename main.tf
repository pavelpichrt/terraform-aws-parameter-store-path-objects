terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.20"
    }
  }
}

variable "prefix" {
  default     = "/config"
  description = "SSM parameter store path prefix under which the config parameters are located."
}

data "aws_ssm_parameters_by_path" "config" {
  path      = var.prefix
  recursive = true
}

output "string" {
  value = {
    for idx, type in data.aws_ssm_parameters_by_path.config.types : trimprefix(data.aws_ssm_parameters_by_path.config.names[idx], var.prefix) => (
      data.aws_ssm_parameters_by_path.config.values[idx]
    ) if type == "String"
  }
}

output "list" {
  value = {
    for idx, type in data.aws_ssm_parameters_by_path.config.types : trimprefix(data.aws_ssm_parameters_by_path.config.names[idx], var.prefix) => (
      split(",", data.aws_ssm_parameters_by_path.config.values[idx])
    ) if type == "StringList"
  }
}
