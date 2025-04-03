# provider.tf
provider "aws" {
  region = var.aws_region
  # Ensure your AWS credentials are configured via environment variables,
  # shared credentials file (~/.aws/credentials), or an IAM instance profile
  # if running Terraform from within AWS.
} 