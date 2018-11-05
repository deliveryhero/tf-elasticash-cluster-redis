provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

module "redis_cluster" {
  source     = "../../"
  name       = "redis-example"
  subnet_ids = ["${module.vpc.elasticache_subnets}"]
  vpc_id     = "${module.vpc.vpc_id}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "redis-example"
  cidr   = "10.0.0.0/16"
  azs    = ["${data.aws_availability_zones.available.names}"]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/25",
  ]

  public_subnets = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/25",
  ]

  elasticache_subnets = [
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/25",
  ]
}
