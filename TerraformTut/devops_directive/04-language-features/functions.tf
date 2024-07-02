// Collection:

variable "list1" {
  type = list(string)
  default = ["a", "b", "c"]
}

variable "list2" {
  type = list(string)
  default = ["d", "e", "f"]
}
output "concatenated_list" {
  value = concat(var.list1, var.list2)
}

// Encoding:

variable "my_string" {
  type = string
  default = "Hello, World!"
}
output "encoded_string" {
  value = base64encode(var.my_string)
}


// Filesystem:

variable "config_file_path" {
  type = string
  default = "config.txt"
}
output "file_content" {
  value = file(var.config_file_path)
}

// Date & Time:

output "current_timestamp" {
  value = timestamp()
}

// Hash & Crypto:

output "md5_hash" {
  value = md5(var.my_string)
}

// IP Network:

variable "cidr_block" {
  type = string
  default = "192.168.0.0/16"
}

variable "newbits" {
  type = number
  default = 8
}

variable "netnum" {
  type = number
  default = 1
}

output "subnet_cidr" {
  value = cidrsubnet(var.cidr_block, var.newbits, var.netnum)
}

// Type Conversion:

variable "number" {
  type = number
  default = 42
}

output "number_as_string" {
  value = tostring(var.number)
}
