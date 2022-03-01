locals {
  automatic_failover_enabled = var.number_cache_clusters > 1 ? true : false
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = var.name
  description                = var.name
  automatic_failover_enabled = local.automatic_failover_enabled
  num_cache_clusters         = var.number_cache_clusters
  node_type                  = var.node_type
  engine_version             = var.engine_version
  parameter_group_name       = aws_elasticache_parameter_group.redis[0].id
  subnet_group_name          = aws_elasticache_subnet_group.redis[0].name
  security_group_ids         = [aws_security_group.redis[0].id]
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  port                       = var.port
  apply_immediately          = var.apply_immediately
  tags                       = var.tags
  multi_az_enabled           = local.automatic_failover_enabled ? var.multi_az_enabled : false
}

resource "aws_elasticache_subnet_group" "redis" {
  count      = var.create_resources ? 1 : 0
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "redis" {
  count  = var.create_resources ? 1 : 0
  name   = "${var.name}-parameter-group"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

resource "aws_security_group" "redis" {
  count       = var.create_resources ? 1 : 0
  name        = var.name
  description = "For ${var.name} redis cluster"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "redis" {
  count                    = length(var.allowed_security_groups)
  type                     = "ingress"
  from_port                = aws_elasticache_replication_group.redis.port
  to_port                  = aws_elasticache_replication_group.redis.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.redis[0].id
}

