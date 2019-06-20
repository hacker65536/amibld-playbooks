locals {
  instance_type = "t2.medium"
}

locals {
  os = {
    amz2     = data.aws_ami.amazonlinux2.id
    amz      = data.aws_ami.amazonlinux.id
    cent7    = data.aws_ami.centos7.id
    cent6    = data.aws_ami.centos6.id
    ubuntu18 = data.aws_ami.ubuntu18.id
  }
}
resource "aws_spot_instance_request" "ec2" {
  count                  = length(local.os)
  instance_type          = local.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  ami                    = element(values(local.os), count.index)
  subnet_id              = tolist(data.aws_subnet_ids.pub.ids)[0]
  vpc_security_group_ids = [data.aws_security_group.def.id]
  volume_tags            = local.tags

  # spot
  //spot_price             = "0.03"
  spot_type            = "one-time"
  wait_for_fulfillment = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "20"
    delete_on_termination = true
  }

  tags = merge(
    local.tags,
    map(
      "Name", "${terraform.workspace}-${element(keys(local.os), count.index)}",
      "Purpose", "testami",
    ),
  )



  provisioner "local-exec" {
    command = join("", formatlist("aws ec2 create-tags --resources ${self.spot_instance_id} --tags Key=\"%s\",Value=\"%s\" --region=${var.region}; ", keys(self.tags), values(self.tags)))
    environment = {
      AWS_DEFAULT_REGION  = var.region
      AWS_DEFAULT_PROFILE = var.profile
    }
  }
}


output "sub" {
  value = tolist(data.aws_subnet_ids.pub.ids)[0]
}
output "ips" {
  #  value = aws_instance.ec2[*].private_ip
  value = {
    for inst in aws_spot_instance_request.ec2 :
    inst.tags["Name"] => inst.private_ip
  }
}
