terraform {

  cloud {
    organization = "Naba_Org"
    workspaces {
      name = "my-webapp"
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
} 

variable "aws_access_key_id" {
  type = string
  sensitive = true
}

# provider
provider "aws" {
  region     = "ap-south-1"
  profile    = "naba93980"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# VPC
data "aws_vpc" "MyVPC1" {
  id = "vpc-0a864f3b893ca1a9c"
}

data "aws_subnet_ids" "MyVPC1_Subnet_Ids" {
  vpc_id = data.aws_vpc.MyVPC1.id
}

locals {
  subnet_ids = data.aws_subnet_ids.MyVPC1_Subnet_Ids.ids
  public_subnet_names = ["MyVPC-PublicSubnet1a", "MyVPC-PublicSubnet1b"]
  private_subnet_names = ["MyVPC-PrivateSubnet1a", "MyVPC-PrivateSubnet1b"]
}

data "aws_subnet" "MyVPC1_Public_Subnets" {
  count = length(local.public_subnet_names)
  filter {
    name   = "tag:Name"
    values = [local.public_subnet_names[count.index]]
  }
}
data "aws_subnet" "MyVPC1_Private_Subnets" {
  count = length(local.private_subnet_names)
  filter {
    name   = "tag:Name"
    values = [local.private_subnet_names[count.index]]
  }
}

# EC2 security group
resource "aws_security_group" "my-web-app-ec2-sg1" {
  name = "instance-security-group"
  vpc_id      = data.aws_vpc.MyVPC1.id
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.my-web-app-ec2-sg1.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# EC2 instances
resource "aws_instance" "instance_1" {

  subnet_id = data.aws_subnet.MyVPC1_Private_Subnets[0].id
  ami             = "ami-0f2e255ec956ade7f"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my-web-app-ec2-sg1.id]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World 1" > index.html
              python3 -m http.server 8080 &
              EOF
  depends_on = [ aws_security_group.my-web-app-ec2-sg1 ]
}

resource "aws_instance" "instance_2" {

  subnet_id = data.aws_subnet.MyVPC1_Private_Subnets[1].id
  ami             = "ami-0f2e255ec956ade7f"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my-web-app-ec2-sg1.id]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World 2" > index.html
              python3 -m http.server 8080 &
              EOF
  depends_on = [ aws_security_group.my-web-app-ec2-sg1 ]
}

# S3 bucket
resource "aws_s3_bucket" "my-web-app-bucket1" {
  bucket_prefix = "devops-directive-web-app-data"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.my-web-app-bucket1.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_crypto_conf" {
  bucket = aws_s3_bucket.my-web-app-bucket1.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



# ALB

# ALB security group
resource "aws_security_group" "my-web-app-alb-sg1" {
  name = "alb-security-group"
  vpc_id = data.aws_vpc.MyVPC1.id
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.my-web-app-alb-sg1.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.my-web-app-alb-sg1.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}

resource "aws_lb" "my-web-app-alb" {
  name               = "my-web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-web-app-alb-sg1.id]
  subnets            = [for subnet in data.aws_subnet.MyVPC1_Public_Subnets : subnet.id]
}

# ALB target group
resource "aws_lb_target_group" "my-web-app-alb-tg1" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.MyVPC1.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.my-web-app-alb-tg1.arn
  target_id        = aws_instance.instance_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.my-web-app-alb-tg1.arn
  target_id        = aws_instance.instance_2.id
  port             = 8080
}

# ALB listener
resource "aws_lb_listener" "my-web-app-alb-listener" {
  load_balancer_arn = aws_lb.my-web-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "my-web-app-alb-listener-rule" {
  listener_arn = aws_lb_listener.my-web-app-alb-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-web-app-alb-tg1.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}


# Route53
resource "aws_route53_zone" "primary" {
  name = "nabajyotimodak.in"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "nabajyotimodak.in"
  type    = "A"

  alias {
    name                   = aws_lb.my-web-app-alb.dns_name
    zone_id                = aws_lb.my-web-app-alb.zone_id
    evaluate_target_health = true
  }
}
