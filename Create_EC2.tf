# As we have already defined provider in IAM_User file it is not required anywhere else

# terraform {
#   required_providers {
#     aws = {
#         source  = "hashicorp/aws"
#         version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

#Getting my public IP from internet so that even it changes, it will get the correct IP
data "http" "my_ip" {
  url = "https://api.ipify.org"
}

#Create key pair
resource "aws_key_pair" "Terraform_EC2_KeyPair" {
  key_name   = "EC2 keypair"
  public_key = file("~/.ssh/id_ed25519.pub")
}

#Create Security group
resource "aws_security_group" "Terraform_ec2_SecurityGP" {
  name = "Terraform_ec2_SecurityGP"
}

#Create inbound rules - SSH
resource "aws_vpc_security_group_ingress_rule" "Terraform_ec2_SecurityGP_Ingress_ssh" {
  description       = "SSH rule"
  security_group_id = aws_security_group.Terraform_ec2_SecurityGP.id
  ip_protocol       = "TCP"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "${data.http.my_ip.body}/32"
}

#Create inbound rules - HTTP
resource "aws_vpc_security_group_ingress_rule" "Terraform_ec2_SecurityGP_Ingress_http" {
  description       = "HTTP rule"
  security_group_id = aws_security_group.Terraform_ec2_SecurityGP.id
  ip_protocol       = "TCP"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "${data.http.my_ip.body}/32"
}

#Create Outbound rules - All traffic
resource "aws_vpc_security_group_egress_rule" "Terraform_ec2_SecurityGP_Engress" {
  description       = "All traffic"
  security_group_id = aws_security_group.Terraform_ec2_SecurityGP.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}


#Create EC2 instance
resource "aws_instance" "terraform_ec2" {
  tags = {
    Name = "Terraform_ec2"
  }
  ami             = "ami-084568db4383264d4"
  instance_type   = "t3.micro"
  key_name        = aws_key_pair.Terraform_EC2_KeyPair.key_name
  user_data       = file("user_data.sh")
  security_groups = [aws_security_group.Terraform_ec2_SecurityGP.name]
}