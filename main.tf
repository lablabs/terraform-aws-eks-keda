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
      service_account_create = var.operator_service_account_create
      service_account_name   = var.operator_service_account_name

      irsa_role_create          = var.operator_irsa_role_create
      irsa_role_name            = var.operator_irsa_role_name
      irsa_policy_enabled       = var.operator_irsa_policy_enabled
      irsa_policy               = var.operator_irsa_policy
      irsa_assume_role_enabled  = var.operator_irsa_assume_role_enabled
      irsa_assume_role_arns     = var.operator_irsa_assume_role_arns
      irsa_permissions_boundary = var.operator_irsa_permissions_boundary
      irsa_additional_policies  = var.operator_irsa_additional_policies
    }
    metric-server = {
      service_account_create = var.metric_server_service_account_create
      service_account_name   = var.metric_server_service_account_name

      irsa_role_create          = var.metric_server_irsa_role_create
      irsa_role_name            = var.metric_server_irsa_role_name
      irsa_policy_enabled       = var.metric_server_irsa_policy_enabled
      irsa_policy               = var.metric_server_irsa_policy
      irsa_assume_role_enabled  = var.metric_server_irsa_assume_role_enabled
      irsa_assume_role_arns     = var.metric_server_irsa_assume_role_arns
      irsa_permissions_boundary = var.metric_server_irsa_permissions_boundary
      irsa_additional_policies  = var.metric_server_irsa_additional_policies
    }
    webhooks = {
      service_account_create = var.webhooks_service_account_create
      service_account_name   = var.webhooks_service_account_name

      irsa_role_create          = var.webhooks_irsa_role_create
      irsa_role_name            = var.webhooks_irsa_role_name
      irsa_policy_enabled       = var.webhooks_irsa_policy_enabled
      irsa_policy               = var.webhooks_irsa_policy
      irsa_assume_role_enabled  = var.webhooks_irsa_assume_role_enabled
      irsa_assume_role_arns     = var.webhooks_irsa_assume_role_arns
      irsa_permissions_boundary = var.webhooks_irsa_permissions_boundary
      irsa_additional_policies  = var.webhooks_irsa_additional_policies
    }
  }

  addon_values = yamlencode({
    rbac = {
      create = var.rbac_create != null ? var.rbac_create : true
    }
    serviceAccount = {
      operator = {
        create = module.addon-irsa["operator"].service_account_create
        name   = module.addon-irsa["operator"].service_account_name
        annotations = module.addon-irsa["operator"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["operator"].iam_role_attributes.arn
        } : tomap({})
      }
      metricServer = {
        create = module.addon-irsa["metric-server"].service_account_create
        name   = module.addon-irsa["metric-server"].service_account_name
        annotations = module.addon-irsa["metric-server"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["metric-server"].iam_role_attributes.arn
        } : tomap({})
      }
      webhooks = {
        create = module.addon-irsa["webhooks"].service_account_create
        name   = module.addon-irsa["webhooks"].service_account_name
        annotations = module.addon-irsa["webhooks"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["webhooks"].iam_role_attributes.arn
        } : tomap({})
      }
    }
  })

  addon_depends_on = []
}
