# modules/ec2/main.tf

resource "aws_instance" "app_server" {
  ami           = "ami-0030945a5e6d38ef4"  # Replace with a valid AMI ID in your region
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

# Output the instance ID of the EC2 instance
output "instance_id" {
  value = aws_instance.app_server.id
  description = "The ID of the EC2 instance"
}

# Output the public IP of the EC2 instance
output "public_ip" {
  value = aws_instance.app_server.public_ip
  description = "The public IP address of the EC2 instance"
}
