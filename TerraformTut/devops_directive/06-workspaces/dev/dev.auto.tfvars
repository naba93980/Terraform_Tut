bucket_name = "naba93980-myawsbucket-dev"
bucket_policy = {
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = "*",
                Action = [
                    "s3:GetObject"
                ],
                Resource = [
                    "arn:aws:s3:::naba93980-myawsbucket-dev/*"
                ]
            }
        ]
    }
