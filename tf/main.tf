# main.tf

# --- IAM Role and Policy for EC2 Instances ---

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Defines permissions needed by the *instances* themselves
data "aws_iam_policy_document" "app_permissions_policy_doc" {
  statement {
    sid    = "S3AppAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    # Grant access to any bucket starting with the project name prefix
    resources = [
      "arn:aws:s3:::${var.project_name}-*",
      "arn:aws:s3:::${var.project_name}-*/*"
    ]
  }

  statement {
    sid    = "CloudWatchLogsAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"] # Adjust if more specific log group ARN is needed
  }

  # Note: Permissions for the service account itself (to create/manage resources)
  # are handled by the credentials Terraform uses, NOT this policy attached to the instance role.
  # This policy is for the application *running* on the EC2 instances.
}

resource "aws_iam_policy" "app_permissions_policy" {
  name        = "${var.project_name}-app-permissions-policy"
  description = "IAM policy granting application permissions for S3 and Logs"
  policy      = data.aws_iam_policy_document.app_permissions_policy_doc.json
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.project_name}-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "app_permissions_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.app_permissions_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.instance_role.name

  tags = {
    Project = var.project_name
  }
}


# --- Security Group ---

resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP and limited SSH traffic"

  ingress {
    description      = "SSH from specific CIDR"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.allowed_ssh_cidr]
  }

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}


# --- EC2 Instances ---

resource "aws_instance" "frontend_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name    = "${var.project_name}-frontend"
    App     = "${var.project_name}-frontend" # Matches requirement: app=lti-recruiting-frontend
    Project = var.project_name
  }
}

resource "aws_instance" "backend_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name    = "${var.project_name}-backend"
    App     = "${var.project_name}-backend" # Matches requirement: app=lti-recruiting-backend
    Project = var.project_name
  }
}


# --- Optional S3 Bucket for CVs ---

resource "random_id" "bucket_suffix" {
  count = var.create_cv_bucket ? 1 : 0 # Only generate if bucket is created

  byte_length = 8
}

resource "aws_s3_bucket" "cv_storage" {
  count = var.create_cv_bucket ? 1 : 0 # Only create if variable is true

  # Bucket names must be globally unique
  bucket = "${var.project_name}-cv-storage-${random_id.bucket_suffix[0].hex}"

  tags = {
    Name    = "${var.project_name}-cv-storage"
    Project = var.project_name
  }
}

# Optional: Block public access to the CV bucket
resource "aws_s3_bucket_public_access_block" "cv_storage_pac" {
 count = var.create_cv_bucket ? 1 : 0

 bucket = aws_s3_bucket.cv_storage[0].id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
} 