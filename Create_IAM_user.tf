# Configuring AWS

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuring AWS provider

provider "aws" {
  region = "us-east-1"
}

# Creating user
resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
}

# OPTIONAL!! Creating user access key for login using CLI 
resource "aws_iam_access_key" "terraform_user_access_key" {
  user = aws_iam_user.terraform_user.name
}

# Getting secret key, this wont show value as sesnitive = true; use this command to see the key -- "terraform output secret_access_key"
output "secret_access_key" {
  value     = aws_iam_access_key.terraform_user_access_key.secret
  sensitive = true
}

# Creating policy for user
data "aws_iam_policy_document" "Create_Terraform_user_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

# Attching Policy to user
resource "aws_iam_user_policy" "Assign_terraform_user_policy" {
  name   = "terraform_user_policy"
  user   = aws_iam_user.terraform_user.name
  policy = data.aws_iam_policy_document.Create_Terraform_user_policy.json

}
