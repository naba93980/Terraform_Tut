terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"

    }
  }
}
provider "aws" {
  region  = "ap-south-1"
  profile = "naba93980"
}

resource "aws_instance" "myinstance1" {
  ami           = "ami-0f2e255ec956ade7f"
  instance_type = "t2.micro"
  key_name = "terraform-tut"
  count = 2
}

resource "aws_key_pair" "terraform-tut" {
  key_name = "terraform-tut"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyaeCwzsRTuK2ZhJ03gW0ph+SknAwoclsLnfdsJcP7cOzLo1okqh2/bmidDG2ok5InqinmWoSPQvDZ+Nl120fbZ2R794SLlK2ePMKndiZ/0x602wNV30fsEvKF6a+i9XMVzuZ5lqVVFDfQjLf8GF7WULCosD4cgRmaX1fR12LLrxyeDARvGtPESSkpo36lVZ+vX2QA1Neu0/pIofEtJAfzSCEvaHM61LeBVPtDxmvdI40wBhx2FVrNVgenvyOKSdVcbpRj6FZiLsb00Y0G98HXuRyU2yOdgTnZAVv1fEPHNUeiif+dNAufrqa8ydPF6zNi9lprZHSg8D6ewm8JAiuj"
}
