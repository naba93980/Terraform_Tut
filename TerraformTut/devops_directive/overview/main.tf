terraform {

  cloud {
    organization = "Naba_Org"
    workspaces {
      name = "overview-code"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"

    }
  }
}

resource "aws_key_pair" "terraform-tut" {
  key_name   = "terraform-tut"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDjmCBM2qERoRhaoMORAV6oL+Y61h8lnHiSauuI4HPXiaNhD+S5J12J1UOc3751+HHGxl9pyzZC8Q2bFja4vNBtN7nVCAZE5NrHcZRsjXlPUNkIXRqmopdnBrBgugNAvpeVeWs17zZ37sBwSBW1PHIUG0UDMGtnEym4W8IRKz++T00isr1cg8BzdkaP+3FPNEWgu0YyfGDsOJvfVKn+7RdDPBbgmANiZ3d6dTzZSZP70Qsj7W//SZwIYbOqobh/B2YUqIRv6MX/s1YM8ljDS2fHINxcAwZvJngGgVShK+U5Y8QUTKZewnmw/gMU/dV/Pn82syMSlaxFRYCfaBt2Y1sgZr0s6mEZlk4hVzXIe6HRWB6KPFU6sb5L3xOtkz2GIs5//fjOvDLsrsGyE/MztMy2UbpC1ejN9n0QByG3/N40pYfc5oXVWW4Eayhuz6dyTf5UaZ5lrE5sgFFZRFA43WFjftiWEoZwKdXn8vdcNUN0SBWnTxC3NdzqSsCUg3TGtk= nabajyotimodak@nabajyotimodak-X510UNR"
}

variable "aws_secret_access_key" {} // set terraform variables in workspace, keep hcl checpoint deselected, those valus will get injected in the file during runtime

variable "aws_access_key_id" {}

provider "aws" {
  region  = "ap-south-1"
  profile = "naba93980"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_instance" "myinstance1" {
  ami           = "ami-0f2e255ec956ade7f"
  instance_type = "t2.micro"
  key_name      = "terraform-tut"
  count         = 2
}


