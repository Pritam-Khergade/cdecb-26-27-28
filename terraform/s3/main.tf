resource "aws_s3_bucket" "s3" {
  bucket = var.bucketname
  tags = local.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration" {
  bucket = aws_s3_bucket.s3.id
  rule {
    id     = "${var.bucketname}-lifecycle"
    status = var.lifecycle_status

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = var.object_expiration
    }
  }
}