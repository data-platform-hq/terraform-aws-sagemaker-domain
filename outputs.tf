output "id" {
  description = "The ID of the Domain"
  value       = try(aws_sagemaker_domain.this[0].id, null)
}

output "arn" {
  description = "The Amazon Resource Name (ARN) assigned by AWS to this Domain"
  value       = try(aws_sagemaker_domain.this[0].arn, null)
}

output "url" {
  description = "The domain's URL"
  value       = try(aws_sagemaker_domain.this[0].url, null)
}

output "single_sign_on_managed_application_instance_id" {
  description = "The SSO managed application instance ID"
  value       = try(aws_sagemaker_domain.this[0].single_sign_on_managed_application_instance_id, null)
}

output "security_group_id_for_domain_boundary" {
  description = "The ID of the security group that authorizes traffic between the RSessionGateway apps and the RStudioServerPro app"
  value       = try(aws_sagemaker_domain.this[0].security_group_id_for_domain_boundary, null)
}

output "home_efs_file_system_id" {
  description = "The ID of the Amazon Elastic File System (EFS) managed by this Domain"
  value       = try(aws_sagemaker_domain.this[0].home_efs_file_system_id, null)
}
