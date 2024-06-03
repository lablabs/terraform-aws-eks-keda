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

    irsa_role_create = false # we are handling IRSA locally

    values = yamlencode({
      rbac = {
        create = var.rbac_create != null ? var.rbac_create : true
      }
      serviceAccount = {
        operator = {
          create = var.keda_operator_service_account_create
          name   = var.keda_operator_service_account_name
          annotations = local.irsa_components["operator"].irsa_role_create ? {
            "eks.amazonaws.com/role-arn" = aws_iam_role.this["operator"].arn
          } : tomap({})
        }
        metricServer = {
          create = var.keda_metric_server_service_account_create
          name   = var.keda_metric_server_service_account_name
          annotations = local.irsa_components["metricServer"].irsa_role_create ? {
            "eks.amazonaws.com/role-arn" = aws_iam_role.this["metricServer"].arn
          } : tomap({})
        }
        webhooks = {
          create = var.keda_webhooks_service_account_create
          name   = var.keda_webhooks_service_account_name
          annotations = local.irsa_components["webhooks"].irsa_role_create ? {
            "eks.amazonaws.com/role-arn" = aws_iam_role.this["webhooks"].arn
          } : tomap({})
        }
      }
    })
  }
}
