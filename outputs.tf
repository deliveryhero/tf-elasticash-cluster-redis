output "id" {
  description = "The ID replication group"
  value       = "${element(split(",", join(",", aws_elasticache_replication_group.redis.*.id)), 0)}"
}

output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = "${element(split(",", join(",", aws_security_group.redis.*.id)), 0)}"
}

output "port" {
  description = "The port of the cluster"
  value       = "${var.port}"
}

output "primary_endpoint_address" {
  description = "The primary endpoint of the cluster"
  value       = "${element(split(",", join(",", aws_elasticache_replication_group.redis.*.primary_endpoint_address)), 0)}"
}
