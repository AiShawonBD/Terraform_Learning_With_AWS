# Provider
provider "aws" {
  region = "us-east-1" # change as needed
}

# 1. Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
    Environment = "Development"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
    Environment = "Development"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTable"
    Environment = "Development"
  }
}

# 4. Create a Subnet 
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # adjust as necessary
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet"
    Environment = "Development"
  }
}

# 5. Associate Subnet with Route Table 
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# 6. Create Security Group to Allow Ports 22, 80, 443 
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
    Environment = "Development"
  }
}

# 7. Create a Network Interface with an IP in the Subnet Created in Step 4 
resource "aws_network_interface" "my_nic" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.my_sg.id]

  tags = {
    Name = "MyNetworkInterface"
    Environment = "Development"
  }
}

# 8. Assign an Elastic IP to the Network Interface Created in Step 7 
resource "aws_eip" "my_eip" {
  domain            = "vpc"  # Use 'domain = "vpc"' instead of 'vpc = true'
  network_interface = aws_network_interface.my_nic.id

  tags = {
    Name = "MyElasticIP"
    Environment = "Development"
  }
}


# 9. Create Ubuntu Server and Install/Enable Apache2 
resource "aws_instance" "my_instance" {
  ami                         = "ami-0866a3c8686eaeeba" # Ubuntu Server 20.04 LTS in us-east-1; adjust as needed
  instance_type               = "t2.micro"             # adjust as needed
  network_interface {
    network_interface_id = aws_network_interface.my_nic.id
    device_index         = 0
  }
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl enable apache2
              systemctl start apache2
              EOF

  tags = {
    Name = "Ubuntu-Apache-Server"
    Environment = "Development"
  }
}


#10.Example output blocks 
output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_id" {
  value = aws_instance.my_instance.id
  description = "The EC2 instance ID"
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
  description = "The VPC ID"
}

output "elastic_ip" {
  value = aws_eip.my_eip.public_ip
  description = "The Elastic IP address attached to the network interface"
}

