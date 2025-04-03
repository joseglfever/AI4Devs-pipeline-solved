# versions.tf
terraform {
  required_version = ">= 1.0" # Specify minimum Terraform version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Lock to specific major version, allow minor/patch updates
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Placeholder for backend configuration - uncomment and configure after creating
  # the S3 bucket and DynamoDB table manually or via separate Terraform config.
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket-name" # CHANGE ME - Must exist
  #   key            = "lti-recruiting/terraform.tfstate" # Path within the bucket
  #   region         = "us-east-1"                        # CHANGE ME - Should match your provider region
  #   encrypt        = true
  #   dynamodb_table = "your-terraform-lock-table"       # CHANGE ME - Must exist for locking
  # }
} 