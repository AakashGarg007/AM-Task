
# -- object/main.tf -- #

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "object" {
  bucket       = var.bucket_name
  key          = "index.html"
  source       = var.source_file #"object/index.html"
  content_type = "text/html"

  etag = filemd5(var.source_file)
  #acl  = "public-read"
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
