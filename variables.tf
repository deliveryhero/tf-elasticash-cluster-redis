variable "name" {
  description = "Name given resources"
  type        = "string"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "subnet_ids" {
  description = "List of subnet IDs to use"
  type        = "list"
}

variable "create_resources" {
  description = "Whether to create the Aurora cluster and related resources"
  default     = true
  type        = "string"
}

variable "number_cache_clusters" {
  description = "Number of nodes in the cluster"
  default     = 1
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  default     = []
}

variable "node_type" {
  description = "Instance type to use"
  default     = "cache.t2.micro"
}

variable "maintenance_window" {
  description = "When to perform maintenance"
  default     = "sun:02:30-sun:03:30"
}

variable "port" {
  description = "The port on which to accept connections"
  default     = 6379
}

variable "apply_immediately" {
  description = "Determines whether or not modifications are applied immediately, or during the maintenance window"
  default     = true
}

variable "notification_topic_arn" {
  type        = "string"
  default     = ""
  description = "Notification topic ARN for the cluster"
}

variable "cloudwatch_create_alarms" {
  type        = "string"
  default     = false
  description = "Whether to enable CloudWatch alarms"
}

variable "cloudwatch_alarm_prefix" {
  type        = "string"
  default     = "redis-"
  description = "String to prefix cloudwatch alarm names with"
}

variable "cloudwatch_alarm_actions" {
  type        = "list"
  default     = []
  description = "Actions for cloudwatch alarms. e.g. an SNS topic"
}

variable "cloudwatch_alarm_default_thresholds" {
  type        = "map"
  default     = {}
  description = "Override default thresholds for CloudWatch alarms. See cloudwatch_alarm_thresholds in cloudwatch.tf for valid keys"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "A map of tags to add to all resources."
}

variable "parameter_group_family" {
  default = "redis4.0"
}

variable "engine_version" {
  description = "Redis engine verions"
  default     = "4.0.10"
}

variable "route53_zone_id" {
  type        = "string"
  default     = ""
  description = "If specified a route53 record will be created"
}

variable "route53_record_appendix" {
  type        = "string"
  default     = ".redis"
  description = "Will be appended to the route53 record. Only used if route53_zone_id is passed also"
}

variable "route53_record_ttl" {
  type        = "string"
  default     = 60
  description = "TTL of route53 record. Only used if route53_zone_id is passed also"
}
