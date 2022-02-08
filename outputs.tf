output "ec2_public_ips" {
	description = "List of public IP addresses of the Redis instances"
  value = aws_instance.redis_server.*.public_ip
}

output "tags" {
  description = "List of tags of the Redis instances"
  value       = aws_instance.redis_server.*.tags
}
