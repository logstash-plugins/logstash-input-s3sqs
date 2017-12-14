resource "aws_instance" "nginx" {
  ami                         = "${data.aws_ami.coreos.id}"
  instance_type               = "t2.small"
  subnet_id                   = "${aws_subnet.subnet.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  user_data                   = "${data.template_file.user_data.rendered}"

  tags {
    Name  = "${var.name}"
    owner = "${var.owner}"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/cloud-init.yaml")}"

  vars {
    github_handle = "${var.github_handle}"
  }
}

data "aws_ami" "coreos" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}
