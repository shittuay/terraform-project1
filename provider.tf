provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket22"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform_lock"
    encrypt        = true
  }
}
