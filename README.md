# terraform


# Terraform AWS Infrastructure Setup

This project demonstrates how to use Terraform to automate the creation of a VPC, Subnet, and EC2 Instance in AWS. The project is structured using Terraform modules to keep the configuration clean and maintainable.

## Prerequisites

Before you begin, ensure that the following tools are installed:

- **Terraform**: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **AWS CLI**: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Configure AWS CLI

Ensure you have configured your AWS CLI with the correct AWS credentials:

```bash
aws configure
```

You will need to enter your:

- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-1`)
- Default output format (e.g., `json`)

---

## Project Structure

```plaintext
terraform-demo2/
│
├── main.tf              # Root Terraform configuration file
├── variables.tf         # Variables used in the root configuration
├── modules/             # Directory containing individual Terraform modules
│   ├── ec2/             # EC2 module
│   │   ├── main.tf      # EC2 instance resource
│   │   └── variables.tf # EC2 module input variables
│   ├── subnet/          # Subnet module
│   │   ├── main.tf      # Subnet resource
│   │   └── variables.tf # Subnet module input variables
│   └── vpc/             # VPC module
│       ├── main.tf      # VPC resource
│       └── variables.tf # VPC module input variables
└── outputs.tf           # Output values for instance_id and public_ip
```

---

## Terraform Configuration

### 1. **Root `main.tf` File**

In the `main.tf` file, the AWS provider is defined, and the modules for VPC, Subnet, and EC2 are called.

```hcl
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

# Outputs
output "instance_id" {
  value = module.ec2_instance.instance_id
  description = "The ID of the EC2 instance"
}

output "public_ip" {
  value = module.ec2_instance.public_ip
  description = "The public IP address of the EC2 instance"
}
```

### 2. **Module: VPC**

In the `modules/vpc/main.tf`, the VPC resource is defined.

```hcl
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
```

### 3. **Module: Subnet**

In the `modules/subnet/main.tf`, the subnet resource is defined.

```hcl
variable "vpc_id" {
  description = "The ID of the VPC where the subnet will be created"
  type        = string
}

resource "aws_subnet" "main_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

output "subnet_id" {
  value = aws_subnet.main_subnet.id
}
```

### 4. **Module: EC2**

In the `modules/ec2/main.tf`, the EC2 instance is created.

```hcl
variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

output "instance_id" {
  value = aws_instance.app_server.id
  description = "The ID of the EC2 instance"
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
  description = "The public IP address of the EC2 instance"
}
```

---

## Steps to Deploy Infrastructure

Follow the steps below to deploy the infrastructure:

### 1. **Initialize Terraform**

Navigate to your project directory and initialize the Terraform configuration.

```bash
terraform init
```

![Screenshot 2025-04-14 190741](https://github.com/user-attachments/assets/a62ba143-2890-4baf-8384-7faf03b5cf70)

This will download the necessary provider plugins and prepare your environment for the next steps.

### 2. **Plan the Execution**

Before applying the configuration, review the changes Terraform will make to your infrastructure by running:

```bash
terraform plan
```

Terraform will show you the resources that will be created and their configuration.

### 3. **Apply the Configuration**

After reviewing the plan, apply the configuration to create the resources.

```bash
terraform apply
```



![Screenshot 2025-04-14 190756](https://github.com/user-attachments/assets/cdafbcf5-8b1e-4322-b698-d7ff0dc94def)


Terraform will prompt you to confirm the changes by typing `yes`. It will then create the resources defined in the configuration.

### 4. **Verify the Outputs**

Once the apply is successful, you can verify the outputs (such as EC2 instance ID and Public IP) by using:

```bash
terraform output
```


![Screenshot 2025-04-14 190809](https://github.com/user-attachments/assets/e4912f7c-5b8b-453a-bd13-d1b7c5243c6c)


This will display the values for the instance ID and public IP of the EC2 instance.

---

## Resources Created

After running the Terraform configuration, the following resources will be created in AWS:

1. **VPC**: A Virtual Private Cloud with a CIDR block of `10.0.0.0/16`.
2. **Subnet**: A subnet with a CIDR block of `10.0.1.0/24` inside the specified availability zone.
3. **EC2 Instance**: An EC2 instance with the selected AMI, instance type `t2.micro`, and assigned to the subnet.

You can find these resources in the AWS Management Console:

- **VPC**: Under **VPC Dashboard**.
- **Subnet**: Under **Subnets** in the **VPC Dashboard**.
- **EC2 Instance**: Under **EC2 Dashboard**.


![Screenshot 2025-04-14 163722](https://github.com/user-attachments/assets/ccad8b4e-d340-4e76-ac2c-b923bde1d654)


![Screenshot 2025-04-14 184103](https://github.com/user-attachments/assets/aaf02c7c-0966-40eb-ba4f-9c1683c61750)


![Screenshot 2025-04-14 184052](https://github.com/user-attachments/assets/af9d9a72-fcb7-4a63-a304-40a43401e0f4)

---

## Clean Up

If you want to delete the resources created by Terraform, use the following command:

```bash
terraform destroy
```

Terraform will prompt you to confirm the destruction. Type `yes` to remove all the resources.

---

## Conclusion

This project demonstrates how to use Terraform to manage AWS resources in a modular and organized way. By following these steps, you can easily extend the configuration to add more resources or modify the existing ones.
