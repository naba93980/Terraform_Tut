# # block
block_type "block_label" "block_arguments" {
  attribute1key = valuel
  attribute2key = value2
}


# # attribute
attribute1key = value1


# # datatypes
"string"
number 2
boolean true false



resource "aws_instance" "resource1" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  count         = 3
  connection  {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

}

# # list
list = ["iteml", "item2", "items3"]
security_groups = ["sg-2132", "sg-12123"]

# #map
map = {
  key1 = "value1"
  key2 = "value2"
  key3 = "value"
}

# # conditional
resource "aws instance" "server" {
  instance type = var.environment == "development" ? "t2.micro" : "t2.small"
}

# #Function
locals { 
 name = "John Cena" 
fruits = ["apple", "banana", "mango"]
message = "Hello ${upper(local.name)}! I know you like ${join(",", local.fruits)}"
}

# #Resourcedependency
resource "aws_instance" "name" {
  vpc_security_group_ids = aws_security_group.mysg.id
}
resource "aws_security_group" "mysg" {
  #inbound rules
}

resource "aws_vpc" "mynewvpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpcname
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.mynewvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Subnet2"
  }
}
