# outputs.tf
output "frontend_instance_public_ip" {
  description = "Public IP address of the frontend EC2 instance"
  value       = aws_instance.frontend_server.public_ip
}

output "backend_instance_public_ip" {
  description = "Public IP address of the backend EC2 instance"
  value       = aws_instance.backend_server.public_ip
}

output "security_group_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app_sg.id
}

output "instance_role_arn" {
  description = "ARN of the IAM role assigned to the instances"
  value       = aws_iam_role.instance_role.arn
}

output "cv_storage_bucket_name" {
  description = "Name of the S3 bucket for CV storage (if created)"
  value       = var.create_cv_bucket ? aws_s3_bucket.cv_storage[0].id : "Not Created"
}

output "cv_storage_bucket_arn" {
  description = "ARN of the S3 bucket for CV storage (if created)"
  value       = var.create_cv_bucket ? aws_s3_bucket.cv_storage[0].arn : "Not Created"
} 