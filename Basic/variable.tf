#Create Your First Variable
variable "instance_type" {
  default = "t2.micro"
}

#Use the Variable in a Resource
resource "aws_instance" "my_instance" {
  ami           = "ami-0866a3c8686eaeeba"  # Example AMI ID
  instance_type = var.instance_type
}

#Change the Variable Value in Different Ways