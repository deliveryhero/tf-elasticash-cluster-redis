locals {
  cloudwatch_create_alarms = var.create_resources ? var.cloudwatch_create_alarms ? var.number_cache_clusters : 0 : 0

  cloudwatch_alarm_default_thresholds = {
    "cpu_utilization" = 70
    "freeable_memory" = 1000000000
    "swap_usage"      = 100000000
  }
}

resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = local.cloudwatch_create_alarms
  alarm_name          = "${var.cloudwatch_alarm_prefix}${var.name}-${count.index + 1}-CPUUtilization"
  alarm_description   = "ElastiCache CPU utilization for redis cluster ${var.name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  alarm_actions       = var.cloudwatch_alarm_actions
  threshold = lookup(
    var.cloudwatch_alarm_default_thresholds,
    "cpu_utilization",
    local.cloudwatch_alarm_default_thresholds["cpu_utilization"],
  )

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = local.cloudwatch_create_alarms
  alarm_name          = "${var.cloudwatch_alarm_prefix}${var.name}-${count.index + 1}-FreeableMemory"
  alarm_description   = "ElastiCache cluster freeable memory for redis cluster ${var.name}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold = lookup(
    var.cloudwatch_alarm_default_thresholds,
    "freeable_memory",
    local.cloudwatch_alarm_default_thresholds["freeable_memory"],
  )
  alarm_actions = var.cloudwatch_alarm_actions

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage" {
  count               = local.cloudwatch_create_alarms
  alarm_name          = "${var.cloudwatch_alarm_prefix}${var.name}-${count.index + 1}-SwapUsage"
  alarm_description   = "ElastiCache swap usage for redis cluster ${var.name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "SwapUsage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Maximum"
  threshold = lookup(
    var.cloudwatch_alarm_default_thresholds,
    "swap_usage",
    local.cloudwatch_alarm_default_thresholds["swap_usage"],
  )
  alarm_actions = var.cloudwatch_alarm_actions
  ok_actions    = var.cloudwatch_alarm_actions

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }
}

