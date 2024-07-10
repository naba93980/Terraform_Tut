terraform {

  cloud {
    organization = "Naba_Org"
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
} 

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


module "s3_bucket" {
  source        = "./s3-bucket"
  bucket_name   = var.bucket_name
  bucket_policy = jsonencode(var.bucket_policy)
}


output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}
