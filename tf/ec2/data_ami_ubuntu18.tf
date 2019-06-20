data "aws_ami" "ubuntu18" {
  most_recent = true

  filter {
    name   = "manifest-location"
    values = ["099720109477/ubuntu/images/hvm-ssd/ubuntu-bionic*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name = "architecture"

    //values = ["arm64"]
    values = ["x86_64"]
  }
  owners = ["099720109477"]
}
