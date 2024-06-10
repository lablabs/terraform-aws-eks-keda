/**
 * # AWS EKS KEDA Controller Terraform module
 *
 * A Terraform module to deploy the [KEDA](https://github.com/kedacore/keda) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-keda/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-keda/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-keda/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-keda/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name = "keda-controller"

    helm_chart_name    = "keda"
    helm_chart_version = "2.14.2"
    helm_repo_url      = "https://kedacore.github.io/charts"
  }

  addon_irsa = {
    operator = {
      service_account_create = var.keda_operator_service_account_create
      service_account_name   = var.keda_operator_service_account_name

      irsa_role_create         = var.keda_operator_irsa_role_create
      irsa_policy_enabled      = var.keda_operator_irsa_policy_enabled
      irsa_policy              = var.keda_operator_irsa_policy
      irsa_assume_role_enabled = var.keda_operator_irsa_assume_role_enabled
      irsa_assume_role_arns    = var.keda_operator_irsa_assume_role_arns
      irsa_additional_policies = var.keda_operator_irsa_additional_policies
    }
    metricServer = {
      service_account_create = var.keda_metric_server_service_account_create
      service_account_name   = var.keda_metric_server_service_account_name

      irsa_role_create         = var.keda_metric_server_irsa_role_create
      irsa_policy_enabled      = var.keda_metric_server_irsa_policy_enabled
      irsa_policy              = var.keda_metric_server_irsa_policy
      irsa_assume_role_enabled = var.keda_metric_server_irsa_assume_role_enabled
      irsa_assume_role_arns    = var.keda_metric_server_irsa_assume_role_arns
      irsa_additional_policies = var.keda_metric_server_irsa_additional_policies
    }
    webhooks = {
      service_account_create = var.keda_webhooks_service_account_create
      service_account_name   = var.keda_webhooks_service_account_name

      irsa_role_create         = var.keda_webhooks_irsa_role_create
      irsa_policy_enabled      = var.keda_webhooks_irsa_policy_enabled
      irsa_policy              = var.keda_webhooks_irsa_policy
      irsa_assume_role_enabled = var.keda_webhooks_irsa_assume_role_enabled
      irsa_assume_role_arns    = var.keda_webhooks_irsa_assume_role_arns
      irsa_additional_policies = var.keda_webhooks_irsa_additional_policies
    }
  }

  addon_values = yamlencode({
    rbac = {
      create = var.rbac_create != null ? var.rbac_create : true
    }
    serviceAccount = {
      operator = {
        create = var.keda_operator_service_account_create
        name   = var.keda_operator_service_account_name
        annotations = length(module.addon-irsa["operator"].iam_role_attributes) > 0 ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["operator"].iam_role_attributes.arn
        } : tomap({})
      }
      metricServer = {
        create = var.keda_metric_server_service_account_create
        name   = var.keda_metric_server_service_account_name
        annotations = length(module.addon-irsa["metricServer"].iam_role_attributes) > 0 ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["metricServer"].iam_role_attributes.arn
        } : tomap({})
      }
      webhooks = {
        create = var.keda_webhooks_service_account_create
        name   = var.keda_webhooks_service_account_name
        annotations = length(module.addon-irsa["webhooks"].iam_role_attributes) > 0 ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["webhooks"].iam_role_attributes.arn
        } : tomap({})
      }
    }
  })
}
