# Terraform module: AWS Elasticache Redis cluster

A Terraform module to create an AWS Elasticache Redis cluster.

Example:

```hcl
module "redis_cluster" {
  source                  = "git@github.com:deliveryhero/tf-elasticash-cluster-redis.git?ref=1.0"
  name                    = "my-app-production"
  number_cache_clusters    = 3
  cloudwatch_create_alarms = true
  allowed_security_groups  = ["${aws_security_group.my-app.id}"]
  apply_immediately        = false
  node_type                = "cache.m3.medium"
  subnet_ids               = ["${module.vpc1.elasticache_subnets}"]
  vpc_id                   = "${module.vpc1.vpc_id}"
}
```

## Documentation generation

Documentation should be modified within `main.tf` and generated using [terraform-docs](https://github.com/segmentio/terraform-docs).
Generate them like so:

```bash
go get github.com/segmentio/terraform-docs
terraform-docs md ./ | cat -s | tail -r | tail -n +2 | tail -r > README.md
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_security_groups | A list of Security Group ID's to allow access to. | string | `<list>` | no |
| apply_immediately | Determines whether or not modifications are applied immediately, or during the maintenance window | string | `true` | no |
| cloudwatch_alarm_actions | Actions for cloudwatch alarms. e.g. an SNS topic | list | `<list>` | no |
| cloudwatch_alarm_default_thresholds | Override default thresholds for CloudWatch alarms. See cloudwatch_alarm_thresholds in cloudwatch.tf for valid keys | map | `<map>` | no |
| cloudwatch_create_alarms | Whether to enable CloudWatch alarms | string | `false` | no |
| create_resources | Whether to create the Aurora cluster and related resources | string | `true` | no |
| engine_version | Redis engine verions | string | `4.0.10` | no |
| maintenance_window | When to perform maintenance | string | `sun:02:30-sun:03:30` | no |
| multi_az_enabled | Specifies whether to enable Multi-AZ Support for the replication group. If true, `number_cache_clusters` must be greater than 1. | bool | `true` | no |
| name | Name given resources | string | - | yes |
| node_type | Instance type to use | string | `cache.t2.micro` | no |
| notification_topic_arn | Notification topic ARN for the cluster | string | `` | no |
| number_cache_clusters | Number of nodes in the cluster | string | `1` | no |
| parameter_group_family |  | string | `redis4.0` | no |
| parameters | A map of parameters to modify in redis param group. | `map(string)` | `{}` | no |
| port | The port on which to accept connections | string | `6379` | no |
| route53_record_appendix | Will be appended to the route53 record. Only used if route53_zone_id is passed also | string | `.redis` | no |
| route53_record_ttl | TTL of route53 record. Only used if route53_zone_id is passed also | string | `60` | no |
| route53_zone_id | If specified a route53 record will be created | string | `` | no |
| subnet_ids | List of subnet IDs to use | list | - | yes |
| tags | A map of tags to add to all resources. | map | `<map>` | no |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID replication group |
| port | The port of the cluster |
| primary_endpoint_address | The primary endpoint of the cluster |
| security_group_id | The security group ID of the cluster |
