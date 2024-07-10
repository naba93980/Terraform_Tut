variable "bucket_name" {
  type    = string
  default = "naba93980-myawsbucket-default"
}

variable "bucket_policy" {
  default = {
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::naba93980-myawsbucket-default/*"
        ]
      }
    ]
  }
}

