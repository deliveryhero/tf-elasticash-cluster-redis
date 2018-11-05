provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

module "redis_cluster" {
  source                   = "../../"
  name                     = "my-app-production"
  number_cache_clusters    = 3
  cloudwatch_create_alarms = true
  notification_topic_arn   = "${aws_sns_topic.my-app-monitoring.arn}"
  allowed_security_groups  = ["${aws_security_group.my-app.id}"]
  apply_immediately        = false
  node_type                = "cache.m3.medium"
  cloudwatch_alarm_actions = ["${aws_sns_topic.my-app-monitoring.arn}"]
  route53_zone_id          = "${aws_route53_zone.vpc_internal_zone.id}"
  subnet_ids               = ["${module.vpc1.elasticache_subnets}"]
  vpc_id                   = "${module.vpc1.vpc_id}"

  tags = {
    app         = "my-app"
    environment = "production"
  }
}

module "vpc1" {
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

# An internal zone to use in VPC
resource "aws_route53_zone" "vpc_internal_zone" {
  name    = "local.vpc"
  comment = "VPC internal zone"

  vpc {
    vpc_id = "${module.vpc1.vpc_id}"
  }
}

# A security group for my-app ec2 instances
resource "aws_security_group" "my-app" {
  name        = "my-app"
  description = "For application my-app"
  vpc_id      = "${module.vpc1.vpc_id}"

  tags = {
    app         = "my-app"
    environment = "production"
  }
}

# An SNS topic for cloudwatch alarm actions. Can be connected to Slack, or email etc
resource "aws_sns_topic" "my-app-monitoring" {
  name = "my-app-monitoring"
}
