resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.s3_bucket}"
  acl           = "private"
  force_destroy = true

  tags {
    Name  = "${var.name}"
    onwer = "${var.owner}"
  }
}

resource "aws_s3_bucket_policy" "write_elb_logs" {
  bucket = "${aws_s3_bucket.bucket.id}"
  policy = "${data.aws_iam_policy_document.push_elb_logs.json}"
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "push_elb_logs" {
  statement {
    sid = "PushELBLogsToS3"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"

  queue {
    queue_arn     = "${aws_sqs_queue.elb_log_queue.arn}"
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}
