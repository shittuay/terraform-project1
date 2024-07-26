# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.terraform_state_dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock"
  }
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-gateway"
  }
}

# Create a Subnet
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = "main-subnet"
  }
}

# Create a Route Table
resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main-route-table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.r.id
}

# Create a Security Group for the EC2 instance
resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

# Create a key pair for the EC2 instance
resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.deployer.public_key_openssh
}

# Save the private key locally
resource "local_file" "deployer_private_key" {
  content  = tls_private_key.deployer.private_key_pem
  filename = "${path.module}/deployer-key.pem"
}

# Create an EC2 instance
resource "aws_instance" "terraform_server" {
  ami                    = "ami-0aff18ec83b712f05"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "terraform-server"
  }
}

# Create an S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "my-s3-bucket21"
  }
}

# Create a Subnet Group for RDS
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "main-subnet-2"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "main-db-subnet-group"
  }
}

# Create a Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "my-rds-sg"
  description = "Allow inbound access to RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an RDS instance
resource "aws_db_instance" "rds_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"  # Use a supported version
  instance_class         = "db.t3.micro"  # Use a supported instance class
  username               = "admin"
  password               = "password"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  tags = {
    Name = "my-rds-instance"
  }
}

# Output the instance public IP
output "instance_ip" {
  value = aws_instance.terraform_server.public_ip
}

# Output the S3 bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.rds_db.endpoint
}