#-- root/main.tf -- # 

module "vpc_a" {
  source           = "./networking"
  vpc_cidr         = var.vpc_cidr_a #"10.1.0.0/16"
  private_sn_count = 1
  public_sn_count  = 1
  name             = "VPC-A"
  public_cidrs     = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr_a, 8, i)]
  private_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr_a, 8, i)]
}


module "security_group_a" {
  source      = "./securitygroup"
  vpc_id      = module.vpc_a.vpc_id
  cidr_blocks = "0.0.0.0/0"
  sg_type_protocol = {
    all = 0

  }
  sg_egrees_ports = [0]

}

module "s3Primary" {
  source      = "./s3"
  bucket_name = "static-app"
  source_file = "s3/index.html"
}

module "s3Failover" {
  source      = "./s3"
  bucket_name = "static-app-f"
  source_file = "s3/index_f.html"
}

module "cloud-front" {
  source      = "./cloud-front"
  s3_primary  = module.s3Primary.bucket_id
  s3_failover = module.s3Failover.bucket_id
  depends_on = [
    module.s3Primary,
    module.s3Failover
  ]
}

module "cdn-oac-bucket-policy-failover" {
  source         = "./cdn-oac"
  bucket_id      = module.s3Failover.bucket_id
  cloudfront_arn = module.cloud-front.cloudfront_arn
  bucket_arn     = module.s3Failover.bucket_arn
}

module "ecr" {
  source              = "./ecr"
  repo_name           = "${local.repository_name}-${terraform.workspace}"
  tag_mutability      = "MUTABLE"
  should_scan_on_push = false
  default_tags        = local.default_tags
}

module "fargate" {
  source                         = "./fargate/"
  aws_region                     = var.aws_region
  app_name                       = local.app_name
  environment                    = terraform.workspace
  default_tags                   = local.default_tags
  vpc_id                         = module.vpc_a.vpc_id
  container_image                = "${module.ecr.ecr_url}:latest"
  cloudwatch_logs_retention_days = 14
  subnets                        = module.vpc_a.private_subnet_id
  memory                         = local.memory
  cpu                            = local.cpu
}

module "sqs" {
  source       = "./sqs"
  app_name     = local.app_name
  environment  = terraform.workspace
  default_tags = local.default_tags
}