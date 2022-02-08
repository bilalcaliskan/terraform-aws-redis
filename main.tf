provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "current" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_key_pair" "redis_key" {
  key_name   = "rediskeypair"
  public_key = "${file(var.public_key)}"
}

resource "aws_security_group" "redis-sg" {
  name = "redis-sg"
	tags = {
		Name    = "redis-sg"
    Service = "redis"
    Region  = var.aws_region
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 16379
    to_port     = 16379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

	egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "redis_server" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux.id
  vpc_security_group_ids = [aws_security_group.redis-sg.id]
  instance_type          = var.instance_type
	key_name      = "${aws_key_pair.redis_key.key_name}"
  subnet_id              = tolist(data.aws_subnet_ids.current.ids)[count.index % length(data.aws_subnet_ids.current.ids)]
  tags = {
    Name    = "${var.instance_name_prefix}${count.index + 1}"
    Service = "redis"
    Region  = var.aws_region
    Ami     = data.aws_ami.amazon_linux.id
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    EOF

  root_block_device {
    volume_size           = var.root_block_device_size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
}
