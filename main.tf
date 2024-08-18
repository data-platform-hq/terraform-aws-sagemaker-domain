resource "aws_sagemaker_domain" "this" {
  count                         = var.create ? 1 : 0
  domain_name                   = var.domain_name
  auth_mode                     = var.auth_mode
  vpc_id                        = var.vpc_id
  subnet_ids                    = var.subnet_ids
  app_security_group_management = var.app_security_group_management
  app_network_access_type       = var.app_network_access_type
  kms_key_id                    = var.kms_key_id
  tags                          = var.tags

  dynamic "retention_policy" {
    for_each = var.retention_policy_home_efs_file_system != null ? [1] : []
    content {
      home_efs_file_system = var.retention_policy_home_efs_file_system
    }
  }

  dynamic "domain_settings" {
    for_each = var.domain_settings != null ? [1] : []
    content {
      execution_role_identity_config = var.domain_settings.execution_role_identity_config
      security_group_ids             = var.domain_settings.security_group_ids

      dynamic "r_studio_server_pro_domain_settings" {
        for_each = var.domain_settings.r_studio_server_pro_domain_settings != null ? [1] : []
        content {
          domain_execution_role_arn    = var.domain_settings.r_studio_server_pro_domain_settings.domain_execution_role_arn
          r_studio_connect_url         = var.domain_settings.r_studio_server_pro_domain_settings.r_studio_connect_url
          r_studio_package_manager_url = var.domain_settings.r_studio_server_pro_domain_settings.r_studio_package_manager_url

          dynamic "default_resource_spec" {
            for_each = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec != null ? [1] : []
            content {
              instance_type               = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.instance_type
              lifecycle_config_arn        = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.lifecycle_config_arn
              sagemaker_image_arn         = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_arn
              sagemaker_image_version_arn = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_version_arn
            }
          }
        }
      }
    }
  }

  default_space_settings {
    execution_role  = var.default_space_settings.execution_role
    security_groups = var.default_space_settings.security_groups

    dynamic "jupyter_server_app_settings" {
      for_each = var.default_space_settings.jupyter_server_app_settings != null ? [1] : []
      content {
        lifecycle_config_arns = var.default_space_settings.jupyter_server_app_settings.lifecycle_config_arns

        dynamic "code_repository" {
          for_each = var.default_space_settings.jupyter_server_app_settings.code_repositories_urls
          content {
            repository_url = code_repository.value
          }
        }

        dynamic "default_resource_spec" {
          for_each = var.default_space_settings.jupyter_server_app_settings.default_resource_spec != null ? [1] : []
          content {
            instance_type               = var.default_space_settings.jupyter_server_app_settings.default_resource_spec.instance_type
            lifecycle_config_arn        = var.default_space_settings.jupyter_server_app_settings.default_resource_spec.lifecycle_config_arn
            sagemaker_image_arn         = var.default_space_settings.jupyter_server_app_settings.default_resource_spec.sagemaker_image_arn
            sagemaker_image_version_arn = var.default_space_settings.jupyter_server_app_settings.default_resource_spec.sagemaker_image_version_arn
          }
        }
      }
    }

    dynamic "kernel_gateway_app_settings" {
      for_each = var.default_space_settings.kernel_gateway_app_settings != null ? [1] : []
      content {
        lifecycle_config_arns = var.default_space_settings.kernel_gateway_app_settings.lifecycle_config_arns

        dynamic "custom_image" {
          for_each = var.default_space_settings.kernel_gateway_app_settings.custom_images
          content {
            app_image_config_name = custom_image.value.app_image_config_name
            image_name            = custom_image.value.image_name
            image_version_number  = custom_image.value.image_version_number
          }
        }

        dynamic "default_resource_spec" {
          for_each = var.default_space_settings.kernel_gateway_app_settings.default_resource_spec != null ? [1] : []
          content {
            instance_type                 = var.default_space_settings.kernel_gateway_app_settings.default_resource_spec.instance_type
            lifecycle_config_arn          = var.default_space_settings.kernel_gateway_app_settings.default_resource_spec.lifecycle_config_arn
            sagemaker_image_arn           = var.default_space_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_arn
            sagemaker_image_version_alias = var.default_space_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_version_alias
            sagemaker_image_version_arn   = var.default_space_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_version_arn
          }
        }
      }
    }
  }

  default_user_settings {
    execution_role  = var.default_user_settings.execution_role
    security_groups = var.default_user_settings.security_groups

    dynamic "canvas_app_settings" {
      for_each = var.default_user_settings.canvas_app_settings != null ? [1] : []
      content {
        dynamic "direct_deploy_settings" {
          for_each = var.default_user_settings.canvas_app_settings.direct_deploy_settings != null ? [1] : []
          content {
            status = var.default_user_settings.canvas_app_settings.direct_deploy_settings.enabled ? "ENABLED" : "DISABLED"
          }
        }

        dynamic "generative_ai_settings" {
          for_each = var.default_user_settings.canvas_app_settings.generative_ai_settings != null ? [1] : []
          content {
            amazon_bedrock_role_arn = var.default_user_settings.canvas_app_settings.generative_ai_settings.amazon_bedrock_role_arn
          }
        }

        dynamic "model_register_settings" {
          for_each = var.default_user_settings.canvas_app_settings.model_register_settings != null ? [1] : []
          content {
            status                                = var.default_user_settings.canvas_app_settings.model_register_settings.enabled ? "ENABLED" : "DISABLED"
            cross_account_model_register_role_arn = var.default_user_settings.canvas_app_settings.model_register_settings.cross_account_model_register_role_arn
          }
        }

        dynamic "time_series_forecasting_settings" {
          for_each = var.default_user_settings.canvas_app_settings.time_series_forecasting_settings != null ? [1] : []
          content {
            status                   = var.default_user_settings.canvas_app_settings.time_series_forecasting_settings.enabled ? "ENABLED" : "DISABLED"
            amazon_forecast_role_arn = var.default_user_settings.canvas_app_settings.time_series_forecasting_settings.amazon_forecast_role_arn
          }
        }

        dynamic "workspace_settings" {
          for_each = var.default_user_settings.canvas_app_settings.workspace_settings != null ? [1] : []
          content {
            s3_artifact_path = var.default_user_settings.canvas_app_settings.workspace_settings.s3_artifact_path
            s3_kms_key_id    = var.default_user_settings.canvas_app_settings.workspace_settings.s3_kms_key_id
          }
        }
      }
    }

    dynamic "jupyter_server_app_settings" {
      for_each = var.default_user_settings.jupyter_server_app_settings != null ? [1] : []
      content {
        lifecycle_config_arns = var.default_user_settings.jupyter_server_app_settings.lifecycle_config_arns

        dynamic "code_repository" {
          for_each = var.default_user_settings.jupyter_server_app_settings.code_repositories_urls
          content {
            repository_url = code_repository.value
          }
        }

        dynamic "default_resource_spec" {
          for_each = var.default_user_settings.jupyter_server_app_settings.default_resource_spec != null ? [1] : []
          content {
            instance_type               = var.default_user_settings.jupyter_server_app_settings.default_resource_spec.instance_type
            lifecycle_config_arn        = var.default_user_settings.jupyter_server_app_settings.default_resource_spec.lifecycle_config_arn
            sagemaker_image_arn         = var.default_user_settings.jupyter_server_app_settings.default_resource_spec.sagemaker_image_arn
            sagemaker_image_version_arn = var.default_user_settings.jupyter_server_app_settings.default_resource_spec.sagemaker_image_version_arn
          }
        }
      }
    }

    dynamic "kernel_gateway_app_settings" {
      for_each = var.default_user_settings.kernel_gateway_app_settings != null ? [1] : []
      content {
        lifecycle_config_arns = var.default_user_settings.kernel_gateway_app_settings.lifecycle_config_arns

        dynamic "custom_image" {
          for_each = var.default_user_settings.kernel_gateway_app_settings.custom_images
          content {
            app_image_config_name = custom_image.value.app_image_config_name
            image_name            = custom_image.value.image_name
            image_version_number  = custom_image.value.image_version_number
          }
        }

        dynamic "default_resource_spec" {
          for_each = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec != null ? [1] : []
          content {
            instance_type               = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.instance_type
            lifecycle_config_arn        = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.lifecycle_config_arn
            sagemaker_image_arn         = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_arn
            sagemaker_image_version_arn = var.default_user_settings.kernel_gateway_app_settings.default_resource_spec.sagemaker_image_version_arn
          }
        }
      }
    }

    dynamic "r_session_app_settings" {
      for_each = var.default_user_settings.r_session_app_settings != null ? [1] : []
      content {
        dynamic "custom_image" {
          for_each = var.default_user_settings.r_session_app_settings.custom_images
          content {
            app_image_config_name = custom_image.value.app_image_config_name
            image_name            = custom_image.value.image_name
            image_version_number  = custom_image.value.image_version_number
          }
        }

        dynamic "default_resource_spec" {
          for_each = var.default_user_settings.r_session_app_settings.default_resource_spec != null ? [1] : []
          content {
            instance_type               = var.default_user_settings.r_session_app_settings.default_resource_spec.instance_type
            lifecycle_config_arn        = var.default_user_settings.r_session_app_settings.default_resource_spec.lifecycle_config_arn
            sagemaker_image_arn         = var.default_user_settings.r_session_app_settings.default_resource_spec.sagemaker_image_arn
            sagemaker_image_version_arn = var.default_user_settings.r_session_app_settings.default_resource_spec.sagemaker_image_version_arn
          }
        }
      }
    }

    dynamic "r_studio_server_pro_app_settings" {
      for_each = var.default_user_settings.r_studio_server_pro_app_settings != null ? [1] : []
      content {
        access_status = var.default_user_settings.r_studio_server_pro_app_settings.access_status_enabled ? "ENABLED" : "DISABLED"
        user_group    = var.default_user_settings.r_studio_server_pro_app_settings.user_group
      }
    }

    dynamic "tensor_board_app_settings" {
      for_each = var.default_user_settings.tensor_board_app_settings != null ? [1] : []
      content {
        default_resource_spec {
          instance_type               = var.default_user_settings.tensor_board_app_settings.default_resource_spec.instance_type
          lifecycle_config_arn        = var.default_user_settings.tensor_board_app_settings.default_resource_spec.lifecycle_config_arn
          sagemaker_image_arn         = var.default_user_settings.tensor_board_app_settings.default_resource_spec.sagemaker_image_arn
          sagemaker_image_version_arn = var.default_user_settings.tensor_board_app_settings.default_resource_spec.sagemaker_image_version_arn
        }
      }
    }

    dynamic "sharing_settings" {
      for_each = var.default_user_settings.sharing_settings != null ? [1] : []
      content {
        notebook_output_option = var.default_user_settings.sharing_settings.notebook_output_option_allowed ? "Allowed" : "Disabled"
        s3_kms_key_id          = var.default_user_settings.sharing_settings.s3_kms_key_id
        s3_output_path         = var.default_user_settings.sharing_settings.s3_output_path
      }
    }
  }
}
