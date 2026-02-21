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
  ami           = data.aws_ami.amazon_linux_image.id
  instance_type = "t3.medium"
  key_name = "dockerKeyPair"
  vpc_security_group_ids = [aws_security_group.docker_prometheus_server_sg.id]
  tags = {
    Name = "Docker_Prometheus_Server"
  }
}

# Graffana Monitoring Server
resource "aws_instance" "Graffana_Monitoring_Server" {
  ami           = data.aws_ami.amazon_linux_image.id
  instance_type = "t3.medium"
  key_name = "dockerKeyPair"
  vpc_security_group_ids = [aws_security_group.graffana_server_sg.id]
  tags = {
    Name = "Graffana_Monitoring_Server"
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
