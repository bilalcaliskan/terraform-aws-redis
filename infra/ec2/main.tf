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

resource "aws_key_pair" "ubuntu_ec2_key" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key)
}

resource "aws_security_group" "ubuntu-sg" {
  name = "ubuntu-sg"
  tags = {
    Name = "ubuntu-sg"
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

resource "aws_security_group" "market-sg" {
  name = "market-sg"
  tags = {
    Name   = "market-sg"
    Region = var.aws_region
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4000
    to_port     = 4000
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

resource "aws_instance" "ubuntu_server" {
  # count                  = var.instance_count
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.ubuntu-sg.id, aws_security_group.market-sg.id]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ubuntu_ec2_key.key_name
  subnet_id              = tolist(data.aws_subnet_ids.current.ids)[count.index % length(data.aws_subnet_ids.current.ids)]
  tags = {
    Name = "${var.instance_name_prefix}${count.index + 1}"
    # Service = "redis"
    Region = var.aws_region
    Ami    = data.aws_ami.ubuntu.id
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt full-upgrade -y
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt install docker-ce
    sudo systemctl enable --now docker

    docker run -p 3000:3000 -d <your username>/frontend
    docker run -p 3001:3000 -d <your username>/admin-fe
    docker run -p 4000:4000 -d <your username>/backend
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
  depends_on = [aws_instance.ubuntu_server]
  content = templatefile("${path.module}/provisioning/hosts.ini.tpl",
    {
      redis_instances = aws_instance.ubuntu_server.*.public_ip
      ansible_user    = var.ansible_user
      private_key     = var.private_key
    }
  )
  filename = "provisioning/hosts.ini"
}

resource "null_resource" "ansible" {
  depends_on = [aws_instance.ubuntu_server, local_file.hosts_cfg]
  provisioner "local-exec" {
    command = <<EOT
      sleep 120;
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-galaxy install --force bilalcaliskan.redis;
      ansible-playbook -i provisioning/hosts.ini provisioning/redis.yaml;
    EOT
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo ${element(aws_instance.ubuntu_server.*.public_ip, 0)} redis.internal redis >> /etc/hosts",
    ]
  }
}
