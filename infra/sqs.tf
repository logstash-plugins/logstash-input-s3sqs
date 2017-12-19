resource "aws_sqs_queue" "elb_log_queue" {
  name_prefix               = "elb-log-queue-"
  message_retention_seconds = 86400
}

data "aws_iam_policy_document" "elb_notify_sqs" {
  statement {
    actions   = ["sqs:SendMessage"]
    resources = ["${aws_sqs_queue.elb_log_queue.arn}"]
    effect    = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition = {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:::${var.s3_bucket}"]
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = "${aws_sqs_queue.elb_log_queue.id}"
  policy    = "${data.aws_iam_policy_document.elb_notify_sqs.json}"
}
