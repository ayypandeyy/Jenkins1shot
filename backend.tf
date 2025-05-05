terraform {
  backend "s3" {
    bucket         = "ayushterra-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}
