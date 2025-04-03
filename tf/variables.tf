# variables.tf
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base name for the project resources"
  type        = string
  default     = "lti-recruiting"
}

variable "instance_type" {
  description = "EC2 instance type for backend and frontend servers (e.g., t3.small)"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 in the specified AWS region. Find AMIs here: https://cloud-images.ubuntu.com/locator/ec2/"
  type        = string
  default     = "ami-08c40ec9ead489470"
  # No default - This MUST be provided by the user, e.g., in terraform.tfvars
  # Example for Ubuntu 22.04 in us-east-1 (verify this is current): ami-08c40ec9ead489470
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access to the instances (e.g., your public IP: '1.2.3.4/32'). Get your IP: https://checkip.amazonaws.com/"
  type        = string
  default     = "1.2.3.4/32"
  # No default - This MUST be provided by the user for security.
}

variable "create_cv_bucket" {
  description = "Set to true to create the optional S3 bucket for CV storage"
  type        = bool
  default     = true
} 