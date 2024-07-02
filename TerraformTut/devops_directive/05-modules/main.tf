terraform {

  cloud {
    organization = "Naba_Org"
    workspaces {
      name = "modules"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"

    }
  }
}


variable "aws_secret_access_key" {
  type = string
  sensitive = true
} // set terraform variables in workspace, keep hcl checpoint deselected, those valus will get injected in the file during runtime

variable "aws_access_key_id" {
  type = string
  sensitive = true
}

provider "aws" {
  region     = "ap-south-1"
  profile    = "naba93980"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
locals {
  bucket_name = "naba93980-myawsbucket2"
  bucket_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = "*",
                Action = [
                    "s3:GetObject"
                ],
                Resource = [
                    "arn:aws:s3:::${local.bucket_name}/*"
                ]
            }
        ]
    })

}
module "s3_bucket" {
  source        = "./s3-bucket"
  bucket_name   = local.bucket_name
  bucket_policy = local.bucket_policy
}


output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}
