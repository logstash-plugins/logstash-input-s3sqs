variable "s3_bucket" {}
variable "name" {}
variable "owner" {}
variable "github_handle" {}

output "instance_ip" {
  value = "${module.infra.instance_ip}"
}

output "elb_dns_name" {
  value = "${module.infra.elb_dns_name}"
}

module "infra" {
  source = "./infra"

  s3_bucket     = "${var.s3_bucket}"
  name          = "${var.name}"
  owner         = "${var.owner}"
  github_handle = "${var.github_handle}"
}
