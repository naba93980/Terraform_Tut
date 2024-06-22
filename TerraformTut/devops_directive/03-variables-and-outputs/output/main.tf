resource "aws_instance" "instance1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.large"
  count         = 5
}

resource "aws_instance" "instance2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.large"
  count         = 5
}
