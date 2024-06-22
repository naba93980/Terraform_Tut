# variables.tf

variable "aws_access_key_id" {
  sensitive = true
}

variable "aws_secret_access_key" {
  sensitive = true
}

locals {
  myregion = "ap-south-1"
  profile = "naba93980"
}
