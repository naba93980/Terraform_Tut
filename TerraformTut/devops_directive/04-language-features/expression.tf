# Example of expression string
variable "message" {
    type    = string
    default = "Hello, World!"
}

output "message_output" {
    value = "The message is: ${var.message}"
}

# Example of conditionals
variable "environment" {
    type    = string
    default = "dev"
}

resource "aws_instance" "example" {
    ami           = var.environment == "dev" ? "ami-0c94855ba95c71c99" : "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
}

# Example of operators
variable "num1" {
    type    = number
    default = 10
}

variable "num2" {
    type    = number
    default = 5
}

output "addition" {
    value = var.num1 + var.num2
}

output "subtraction" {
    value = var.num1 - var.num2
}

output "multiplication" {
    value = var.num1 * var.num2
}

output "division" {
    value = var.num1 / var.num2
}

# Example for loop expressions
variable "list" {
    type    = list(string)
    default = ["apple", "banana", "cherry"]
}

output "upper_list" {
    value = [for s in var.list : upper(s)]
}


# Example for splat expressions
output "list_ids" {
    value = var.list[*].id
}

# Example for dynamic blocks
variable "ports" {
    type = list(number)
    default = [80, 443, 8080]
}

resource "aws_security_group" "example" {
    name        = "example"
    description = "Example security group"

    dynamic "ingress" {
        for_each = var.ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

# Example for type constraints
variable "name" {
    type = string
}

# Example for version constraints
terraform {
    required_version = ">= 0.14"
}