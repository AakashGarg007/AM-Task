# -- variables.tf -- 

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_cidr_a" {
  default = "10.1.0.0/16"
}

locals {
  cpu             = 512
  memory          = 1024
  app_name        = "am-task"
  repository_name = local.app_name
  default_tags = {
    orchestrator = "terraform",
    project      = local.app_name
    team         = "Aakash"
    env          = "dev"
  }
}
