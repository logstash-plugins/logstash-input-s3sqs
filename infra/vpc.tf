resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name       = "${var.name}"
    managed-by = "terraform"
    owned-by   = "${var.owner}"
    created-on = "${timestamp()}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["tags"]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name       = "${var.name}"
    managed-by = "terraform"
    owner      = "${var.owner}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.0.0/24"

  map_public_ip_on_launch = true

  tags {
    Name       = "${var.name}"
    managed-by = "terraform"
    owner      = "${var.owner}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name       = "${var.name}"
    managed-by = "terraform"
    owned-by   = "${var.owner}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "default" {
  route_table_id         = "${aws_route_table.rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "rta" {
  subnet_id      = "${aws_subnet.subnet.id}"
  route_table_id = "${aws_route_table.rt.id}"
}
