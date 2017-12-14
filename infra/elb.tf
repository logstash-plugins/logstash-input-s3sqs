resource "aws_elb" "elb" {
  subnets         = ["${aws_subnet.subnet.id}"]
  security_groups = ["${aws_security_group.sg.id}"]

  access_logs {
    bucket        = "${aws_s3_bucket.bucket.id}"
    bucket_prefix = "logs"
    interval      = 5                            # minutes
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances = ["${aws_instance.nginx.id}"]

  tags {
    Name  = "${var.name}"
    owner = "${var.owner}"
  }
}
