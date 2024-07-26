```markdown
# Terraform AWS Infrastructure

This project sets up a complete infrastructure on AWS using Terraform. The infrastructure includes:

- A VPC with two subnets
- An Internet Gateway
- A Route Table and its association with the subnets
- An EC2 instance
- S3 buckets
- An RDS instance
- An IAM user with permissions

## Prerequisites

- Terraform installed on your local machine
- AWS account with the necessary permissions
- AWS CLI configured with your credentials

## Configuration

### Variables

The following variables are used in the Terraform configuration and can be found in `variables.tf`:

- `region`: The AWS region to deploy resources in. Default is `us-west-2`.
- `vpc_cidr`: CIDR block for the VPC. Default is `10.0.0.0/16`.
- `subnet_cidrs`: CIDR blocks for the subnets. Default is `10.0.1.0/24` and `10.0.2.0/24`.
- `instance_type`: Type of EC2 instance. Default is `t2.micro`.
- `db_name`: Name of the RDS database. Default is `mydb`.
- `db_user`: Username for the RDS database. Default is `admin`.
- `db_password`: Password for the RDS database. Default is `mypassword`.
- `s3_bucket_name`: Name of the S3 bucket. Default is `my-unique-bucket-name-2024-unique`.
- `key_pair_name`: Name of the key pair for EC2 instance. Default is `deployer-key`.

### IAM Policy

Ensure the `abi` user has the following IAM policy attached:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Permissions",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::my-terraform-state-bucket22",
        "arn:aws:s3:::my-terraform-state-bucket22/*"
      ]
    },
    {
      "Sid": "DynamoDBPermissions",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
        "dynamodb:DescribeTable",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:us-west-2:YOUR_ACCOUNT_ID:table/terraform-lock"
    }
  ]
}
```

Replace `YOUR_ACCOUNT_ID` with your actual AWS account ID.

## Usage

### Initialize Terraform

Run the following command to initialize Terraform. This command sets up the backend configuration and initializes the provider plugins.

```sh
terraform init
```

### Validate the Configuration

Run the following command to validate the Terraform configuration files.

```sh
terraform validate
```

### Apply the Configuration

Run the following command to create the resources defined in the configuration files. You will be prompted to confirm the actions.

```sh
terraform apply
```

### Outputs

After applying the configuration, Terraform will output the following:

- The public IP of the EC2 instance
- The name of the S3 bucket
- The endpoint of the RDS instance

### Example Outputs in `main.tf`

Ensure your `main.tf` includes outputs for key resources:

```hcl
# Output the instance public IP
output "instance_ip" {
  value = aws_instance.terrafor_server.public_ip
}

# Output the S3 bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.rds_db.endpoint
}
```

## Troubleshooting

If you encounter any issues, please check the following:

- Ensure the IAM user has the correct permissions.
- Verify the AMI ID is valid for the specified region.
- Ensure the VPC has DNS support enabled.
- Ensure the DB subnet group covers at least two availability zones.

For further assistance, please refer to the Terraform and AWS documentation.

## Cleanup

To clean up the resources created by Terraform, run the following command:

```sh
terraform destroy
```

This command will prompt you to confirm the destruction of the resources.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
```

This updated `README.md` includes detailed steps for configuration, usage, troubleshooting, and cleanup, reflecting the changes made to the Terraform configuration.
