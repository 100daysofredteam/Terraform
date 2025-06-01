module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  environment = terraform.workspace
}

module "public_subnet" {
  source                  = "./modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  name                    = "public"
  environment             = terraform.workspace
}

module "internet_gateway" {
  source      = "./modules/internet_gateway"
  vpc_id      = module.vpc.vpc_id
  environment = terraform.workspace
}

module "route_tables" {
  source           = "./modules/route_tables"
  vpc_id           = module.vpc.vpc_id
  igw_id           = module.internet_gateway.igw_id
  public_subnet_id = module.public_subnet.subnet_id
  environment      = terraform.workspace
}

# Get the user's current public IP
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Convert it to CIDR notation
locals {
  my_ip_cidr = "${trimspace(data.http.my_ip.response_body)}/32"
}

module "ec2_ssh_key" {
  source            = "./modules/ssh_key"
  key_name          = var.key_name
  environment       = terraform.workspace
  write_private_key = true
}

module "ec2_sg" {
  source      = "./modules/security_group"
  name        = "ec2-sg"
  vpc_id      = module.vpc.vpc_id
  environment = terraform.workspace
  ingress_rules = [
    {
      description = "SSH access from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.my_ip_cidr, var.public_subnet_cidr]
  }]
  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "metadata_lab_s3" {
  source        = "./modules/s3_bucket"
  bucket_name   = "my-redteam-lab-bucket-${random_id.suffix.hex}"
  file_name_key = "secret.txt"
  file_content  = "This is a secret file for red team metadata API lab."
}


resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_read_role_${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "attach_s3_readonly" {
  name       = "attach_s3_readonly_${random_id.suffix.hex}"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile_${random_id.suffix.hex}"
  role = aws_iam_role.ec2_role.name
}


module "aws_metadata_api_ec2" {
  source               = "./modules/ec2_instance"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = module.public_subnet.subnet_id
  security_group_id    = module.ec2_sg.sg_id
  key_name             = module.ec2_ssh_key.key_pair_name
  instance_name        = "aws_metadata_api_ec2"
  environment          = terraform.workspace
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}

