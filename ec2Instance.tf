data "aws_ami" "amazon_linux_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["232789950773"] # Amazon
}

resource "aws_instance" "amazon_linux_instance" {
  ami           = data.aws_ami.amazon_linux_image.id
  instance_type = "t3.micro"

  tags = {
    Name = "amazon_linux_instance_terraform_demo"
  }
}