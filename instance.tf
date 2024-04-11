resource "aws_instance" "terraform_ansible" {
  ami           = var.amis.us-east-1-ubuntu-22
  instance_type = var.instance_type.t2
  tags = {
    Name = "terraform_ansible"
  }
  vpc_security_group_ids = [aws_security_group.general_access.id]
}

resource "aws_instance" "terraform_ansible_jenkins" {
  count         = 2
  ami           = var.amis.us-east-1-ubuntu-20
  instance_type = var.instance_type.t2
  tags = {
    Name = "terraform_ansible_jenkins_${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.general_access.id]
}