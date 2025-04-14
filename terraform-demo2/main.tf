# Root main.tf file

provider "aws" {
  region = "us-east-1"  # Specify your AWS region here
}

# Call VPC module
module "vpc" {
  source = "./modules/vpc"
}

# Call Subnet module
module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
}

# Call EC2 instance module
module "ec2_instance" {
  source    = "./modules/ec2"
  subnet_id = module.subnet.subnet_id
}

# Output variables to display in the terminal
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "subnet_id" {
  value       = module.subnet.subnet_id
  description = "The ID of the subnet"
}

output "instance_id" {
  value       = module.ec2_instance.instance_id
  description = "The ID of the EC2 instance"
}

output "public_ip" {
  value       = module.ec2_instance.public_ip
  description = "The public IP of the EC2 instance"
}
