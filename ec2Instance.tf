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

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "amazon_linux_instance" {
  ami           = data.aws_ami.amazon_linux_image.id
  instance_type = "t3.micro"

  tags = {
    Name = "amazon_linux_instance_terraform_demo"
  }
}

resource "aws_s3_bucket" "s3_demo_bucket" {
  bucket = "my-tf-test-bucket-akhilkumar0024"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}