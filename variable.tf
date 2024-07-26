variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the Subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "db_name" {
  description = "Name of the RDS database"
  default     = "mydb"
}

variable "db_user" {
  description = "Username for the RDS database"
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS database"
  default     = "mypassword"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "my-s3-bucket21"
}

variable "terraform_state_bucket" {
  description = "S3 bucket name for storing Terraform state"
  default     = "my-terraform-state-bucket22"
}

variable "terraform_state_key" {
  description = "S3 key for the Terraform state file"
  default     = "terraform/state/terraform.tfstate"
}

variable "terraform_state_dynamodb_table" {
  description = "DynamoDB table for Terraform state locking"
  default     = "terraform_lock"
}

variable "key_pair_name" {
  description = "Name of the key pair for EC2 instance"
  default     = "deployer-key"
}
