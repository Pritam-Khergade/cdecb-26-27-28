resource "aws_s3_bucket" "this" {
  bucket = lower(format("%s-%s-%s-logs", random_string.this.id, var.namespace, var.env))
  #tags   = var.tags  
}

resource "random_string" "this" {
  length  = 4
  special = false
  lower   = true
  numeric = false
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}/${var.env}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    actions   = ["s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}/${var.env}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.id}"]
    actions   = ["s3:GetBucketAcl"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}