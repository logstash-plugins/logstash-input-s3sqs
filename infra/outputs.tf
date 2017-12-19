output "instance_ip" {
  value = "${aws_instance.nginx.public_ip}"
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "sqs_url" {
  value = "${aws_sqs_queue.elb_log_queue.id}"
}
