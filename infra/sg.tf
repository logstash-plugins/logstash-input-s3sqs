resource "aws_security_group" "sg" {
  name_prefix = "${var.name}-"
  description = "Default Security group for ${var.name}"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    managed-by = "terraform"
    owner      = "${var.owner}"
  }

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Description = "Default Security group for ${var.name}"
  }
}
