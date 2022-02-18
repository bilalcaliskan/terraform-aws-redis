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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "redis_ec2_key" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key)
}

resource "aws_security_group" "redis-sg" {
  name = "redis-sg"
  tags = {
    Name = "redis-sg"
    #Service = "redis"
    Region = var.aws_region
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
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.redis-sg.id]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.redis_ec2_key.key_name
  subnet_id              = tolist(data.aws_subnet_ids.current.ids)[count.index % length(data.aws_subnet_ids.current.ids)]

  tags = {
    Name    = "${var.instance_name_prefix}${count.index + 1}"
    Service = "redis"
    Region  = var.aws_region
    Ami     = data.aws_ami.ubuntu.id
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt full-upgrade -y
  EOF

  root_block_device {
    volume_size           = var.root_block_device_size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
}

# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  depends_on = [aws_instance.redis_server]
  content = templatefile("${path.module}/provisioning/hosts.ini.tpl",
    {
      redis_instances = aws_instance.redis_server.*.public_ip
      ansible_user    = var.ansible_user
      private_key     = var.private_key
    }
  )
  filename = "provisioning/hosts.ini"
}

resource "null_resource" "ansible" {
  depends_on = [aws_instance.redis_server, local_file.hosts_cfg]
  provisioner "local-exec" {
    command = <<EOT
      sleep 120;
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-galaxy install --force bilalcaliskan.redis,v0.0.6;
      ansible-playbook -i provisioning/hosts.ini provisioning/redis.yaml;
    EOT
  }
}
