output "ec2_public_ips" {
  description = "List of public IP addresses of the EC2 instances"
  value       = aws_instance.redis_server.*.public_ip
}

