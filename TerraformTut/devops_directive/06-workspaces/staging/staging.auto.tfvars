bucket_name = "naba93980-myawsbucket-staging"
bucket_policy = {
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    "AWS": "arn:aws:iam::975050244959:user/naba93980"
                }
                Action = [
                    "s3:GetObject"
                ],
                Resource = [
                    "arn:aws:s3:::naba93980-myawsbucket-staging/*"
                ]
            }
        ]
    }