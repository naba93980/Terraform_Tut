variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "naba93980-myawsbucket-default"
}

variable "bucket_policy" {
  description = "The policy of the S3 bucket"
  type        = string
  default     = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::975050244959:user/naba93980"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::naba93980-myawsbucket-default/*"
            
        }
    ]
}
EOF
}
