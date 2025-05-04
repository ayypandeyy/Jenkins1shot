#!/bin/bash
#Installing apache2 server on the EC2 instance created using Terraform
export DEBIAN_FRONTEND=noninteractive
sudo apt update -y

sudo apt-get install -y apache2 \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold"
  
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Apache2 installation and setup complete."
