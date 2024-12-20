#Create Your First Variable
variable "instance_type" {
  default = "t2.micro"
}

#Use the Variable in a Resource
resource "aws_instance" "my_instance" {
  ami           = "ami-0866a3c8686eaeeba"  # Example AMI ID
  instance_type = var.instance_type
}

#1. Change the Variable Value in Different Ways
/* Create a file in your project folder called terraform.tfvars. Inside this file, add the variable and set its value. For example: 

instance_type = "t3.micro"

Now, whenever you run terraform apply, Terraform will automatically pick up the value from 

terraform.tfvars.

This is the easiest way to change variable values in one place without touching the main code. */

#2. Using Command Line

#You can also set the variable value directly in the command line when you run Terraform:

terraform apply -var="instance_type=t3.micro"

/* In this example, -var="instance_type=t3.micro" tells Terraform to use "t3.micro" instead of the default.
Use this method if you only want to change the value temporarily for one run. */

