resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}    
 
resource "aws_s3_bucket_public_access_block" "forbucketaccess" {
    bucket = aws_s3_bucket.bucket.id
    block_public_policy     = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.bucket.id                     
    policy = var.bucket_policy
    depends_on = [ aws_s3_bucket_public_access_block.forbucketaccess ]
}

# data "aws_iam_policy_document" "s3_bucket_policy" {
#   statement {
#     actions = [
#       "s3:GetObject"
#     ]

#     resources = [
#       "${aws_s3_bucket.bucket.arn}/*"
#     ]
#   }
# }
