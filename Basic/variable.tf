#Variable Declear

variable "instance_type" {
  default = "t2.micro"
}

#User of Variable
resource "aws_instance" "my_instance" {
  ami           = "ami-0866a3c8686eaeeba"  # Example AMI ID
  instance_type = var.instance_type
}
