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

output "_" {
  value = zipmap(
    [for name in data.aws_ssm_parameters_by_path.config.names : trimprefix(name, var.prefix)],
    [for idx, type in data.aws_ssm_parameters_by_path.config.types : (
      type == "StringList" ?
      split(",", data.aws_ssm_parameters_by_path.config.values[idx]) :
      data.aws_ssm_parameters_by_path.config.values[idx]
    )]
  )
}
