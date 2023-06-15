variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# SageMaker domain
################################################################################
variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "auth_mode" {
  description = "The mode of authentication that members use to access the domain. Valid values are IAM and SSO"
  type        = string
}

variable "default_user_settings" {
  description = "The default user settings"
  type = object({
    execution_role  = string                 #  The execution role ARN for the user
    security_groups = optional(list(string)) # A list of security group IDs that will be attached to the user
    canvas_app_settings = optional(object({
      model_register_settings = optional(object({
        enabled                               = optional(bool, false) # Describes whether the integration to the model registry is enabled or disabled in the Canvas application
        cross_account_model_register_role_arn = optional(string)      # The Amazon Resource Name (ARN) of the SageMaker model registry account
      }))
      time_series_forecasting_settings = optional(object({
        enabled                  = optional(bool, false)
        amazon_forecast_role_arn = optional(string) # The IAM role that Canvas passes to Amazon Forecast for time series forecasting
      }))
    }))
    jupyter_server_app_settings = optional(object({       # The Jupyter server's app settings
      code_repositories_urls = optional(list(string), []) # A list of Git repositories that SageMaker automatically displays to users for cloning in the JupyterServer application
      lifecycle_config_arns  = optional(list(string))     # The Amazon Resource Name (ARN) of the Lifecycle Configurations
      default_resource_spec = optional(object({
        instance_type               = optional(string) # The instance type that the image version runs on
        lifecycle_config_arn        = optional(string) # The Amazon Resource Name (ARN) of the Lifecycle Configuration attached to the Resource
        sagemaker_image_arn         = optional(string) # The ARN of the SageMaker image that the image version belongs to
        sagemaker_image_version_arn = optional(string) # The ARN of the image version created on the instance
      }))
    }))
    kernel_gateway_app_settings = optional(object({ # The kernel gateway app settings
      custom_images = optional(list(object({
        app_image_config_name = string           # The name of the App Image Config
        image_name            = string           # The name of the Custom Image
        image_version_number  = optional(number) # The version number of the Custom Image
      })), [])
      default_resource_spec = optional(object({
        instance_type               = optional(string) # The instance type that the image version runs on
        lifecycle_config_arn        = optional(string) # The Amazon Resource Name (ARN) of the Lifecycle Configuration attached to the Resource
        sagemaker_image_arn         = optional(string) # The ARN of the SageMaker image that the image version belongs to
        sagemaker_image_version_arn = optional(string) # The ARN of the image version created on the instance
      }))
      lifecycle_config_arns = optional(list(string)) # The Amazon Resource Name (ARN) of the Lifecycle Configurations
    }))
    r_session_app_settings = optional(object({ # The RSession app settings
      custom_images = optional(list(object({
        app_image_config_name = string           # The name of the App Image Config
        image_name            = string           # The name of the Custom Image
        image_version_number  = optional(number) # The version number of the Custom Image
      })), [])
      default_resource_spec = optional(object({
        instance_type               = optional(string) # The instance type that the image version runs on
        lifecycle_config_arn        = optional(string) # The Amazon Resource Name (ARN) of the Lifecycle Configuration attached to the Resource
        sagemaker_image_arn         = optional(string) # The ARN of the SageMaker image that the image version belongs to
        sagemaker_image_version_arn = optional(string) # The ARN of the image version created on the instance
      }))
    }))
    r_studio_server_pro_app_settings = optional(object({ # A collection of settings that configure user interaction with the RStudioServerPro app
      access_status_enabled = optional(bool)             #  Indicates whether the current user has access to the RStudioServerPro app
      user_group            = optional(string)           # The level of permissions that the user has within the RStudioServerPro app
    }))
    tensor_board_app_settings = optional(object({ # The TensorBoard app settings
      default_resource_spec = optional(object({
        instance_type               = optional(string) # The instance type that the image version runs on
        lifecycle_config_arn        = optional(string) # The Amazon Resource Name (ARN) of the Lifecycle Configuration attached to the Resource
        sagemaker_image_arn         = optional(string) # The ARN of the SageMaker image that the image version belongs to
        sagemaker_image_version_arn = optional(string) # The ARN of the image version created on the instance
      }))
    }))
    sharing_settings = optional(object({                # The sharing settings
      notebook_output_option_allowed = optional(bool)   # Whether to include the notebook cell output when sharing the notebook
      s3_kms_key_id                  = optional(string) # When notebook_output_option is Allowed, the AWS Key Management Service (KMS) encryption key ID used to encrypt the notebook cell output in the Amazon S3 bucket
      s3_output_path                 = optional(string) # When notebook_output_option is Allowed, the Amazon S3 bucket used to save the notebook cell output
    }))
  })
}

variable "vpc_id" {
  description = "The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses for communication"
  type        = string
}

variable "subnet_ids" {
  description = "The VPC subnets that Studio uses for communication"
  type        = list(string)
}

variable "app_network_access_type" {
  description = "Specifies the VPC used for non-EFS traffic"
  type        = string
  default     = "PublicInternetOnly"
}

variable "app_security_group_management" {
  description = "The entity that creates and manages the required security groups for inter-app communication in VPCOnly mode. Valid values are Service and Customer"
  type        = string
  default     = null
}

variable "domain_settings" {
  description = "The domain's settings"
  type = object({
    execution_role_identity_config = optional(string)       # The configuration for attaching a SageMaker user profile name to the execution role as a sts:SourceIdentity key AWS Docs. Valid values are USER_PROFILE_NAME and DISABLED
    security_group_ids             = optional(list(string)) # The security groups for the Amazon Virtual Private Cloud that the Domain uses for communication between Domain-level apps and user apps
    r_studio_server_pro_domain_settings = optional(object({ # A collection of settings that configure the RStudioServerPro Domain-level app
      domain_execution_role_arn    = string                 # The ARN of the execution role for the RStudioServerPro Domain-level app
      r_studio_connect_url         = optional(string)       # A URL pointing to an RStudio Connect server
      r_studio_package_manager_url = optional(string)       # A URL pointing to an RStudio Package Manager server
      default_resource_spec = optional(object({
        instance_type               = optional(string) # The instance type that the image version runs on
        lifecycle_config_arn        = optional(string) # The Amazon Resource Name (ARN) of the Lifecycle Configuration attached to the Resource
        sagemaker_image_arn         = optional(string) # The ARN of the SageMaker image that the image version belongs to
        sagemaker_image_version_arn = optional(string) # The ARN of the image version created on the instance
      }))
    }))
  })
  default = null
}

variable "kms_key_id" {
  description = "The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain"
  type        = string
  default     = null
}

variable "retention_policy_home_efs_file_system" {
  description = "The retention policy for data stored on an Amazon Elastic File System (EFS) volume. Valid values are Retain or Delete"
  type        = string
  default     = null
}
