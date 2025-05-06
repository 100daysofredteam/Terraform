terraform {
  backend "s3" {
    bucket         = "redteam-terraform-state"
    key            = "default/ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "redteam-terraform-locks"
    encrypt        = true
  }
}
