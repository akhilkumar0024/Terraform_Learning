data "aws_ami" "amazon_linux_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

# Docker Prometheus Server
resource "aws_instance" "Docker_Prometheus_Server" {
  ami           = "ami-051a31ab2f4d498f5"
  instance_type = "t3.medium"
  key_name = "dockerKeyPair"
  vpc_security_group_ids = [aws_security_group.docker_prometheus_server_sg.id]
  tags = {
    Name = "Docker_Prometheus_Server"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}

# Graffana Monitoring Server
resource "aws_instance" "Graffana_Monitoring_Server" {
  ami           = "ami-051a31ab2f4d498f5"
  instance_type = "t3.medium"
  key_name = "dockerKeyPair"
  vpc_security_group_ids = [aws_security_group.graffana_server_sg.id]
  tags = {
    Name = "Graffana_Monitoring_Server"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}


# Security Group for Graffana Server
resource "aws_security_group" "graffana_server_sg" {
  name        = "graffana-server-sg"
  description = "Security group for Graffana server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Docker Server
resource "aws_security_group" "docker_prometheus_server_sg" {
  name        = "docker-prometheus-server-sg"
  description = "Security group for Docker and Prometheus server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Control state for Docker/Prometheus Server
resource "aws_ec2_instance_state" "docker_server_state" {
  instance_id = aws_instance.Docker_Prometheus_Server.id
  state       = "running" # Change to "running" to start it back up
}

# Control state for Grafana Server
resource "aws_ec2_instance_state" "grafana_server_state" {
  instance_id = aws_instance.Graffana_Monitoring_Server.id
  state       = "running" # Change to "running" to start it back up
}