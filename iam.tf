locals {
  irsa_role_create      = var.enabled == true && var.rbac_create == true
  irsa_role_name_prefix = try(coalesce(var.irsa_role_name_prefix, var.helm_release_name), "")
  irsa_role_name        = try(trim("${local.irsa_role_name_prefix}-${var.helm_chart_name}", "-"), "")

  irsa_components = {
    operator = {
      irsa_role_create         = local.irsa_role_create && var.keda_operator_service_account_create == true && var.keda_operator_irsa_role_create == true
      irsa_role_name_prefix    = "${local.irsa_role_name_prefix}-operator"
      irsa_role_name           = "${local.irsa_role_name}-operator"
      irsa_policy_enabled      = var.keda_operator_irsa_policy_enabled == true && try(length(var.keda_operator_irsa_policy) > 0, false)
      irsa_policy              = var.keda_operator_irsa_policy
      irsa_assume_role_enabled = var.keda_operator_irsa_assume_role_enabled == true && try(length(var.keda_operator_irsa_assume_role_arns) > 0, false)
      irsa_assume_role_arns    = var.keda_operator_irsa_assume_role_arns
      irsa_additional_policies = var.keda_operator_irsa_additional_policies
      service_account_name     = var.keda_operator_service_account_name
    }
    metricServer = {
      irsa_role_create         = local.irsa_role_create && var.keda_metric_server_service_account_create == true && var.keda_metric_server_irsa_role_create == true
      irsa_role_name_prefix    = "${local.irsa_role_name_prefix}-metrics-server"
      irsa_role_name           = "${local.irsa_role_name}-metrics-server"
      irsa_policy_enabled      = var.keda_metric_server_irsa_policy_enabled == true && try(length(var.keda_metric_server_irsa_policy) > 0, false)
      irsa_policy              = var.keda_metric_server_irsa_policy
      irsa_assume_role_enabled = var.keda_metric_server_irsa_assume_role_enabled == true && try(length(var.keda_metric_server_irsa_assume_role_arns) > 0, false)
      irsa_assume_role_arns    = var.keda_metric_server_irsa_assume_role_arns
      irsa_additional_policies = var.keda_metric_server_irsa_additional_policies
      service_account_name     = var.keda_metric_server_service_account_name
    }
    webhooks = {
      irsa_role_create         = local.irsa_role_create && var.keda_webhooks_service_account_create == true && var.keda_webhooks_irsa_role_create == true
      irsa_role_name_prefix    = "${local.irsa_role_name_prefix}-webhooks"
      irsa_role_name           = "${local.irsa_role_name}-webhooks"
      irsa_policy_enabled      = var.keda_webhooks_irsa_policy_enabled == true && try(length(var.keda_webhooks_irsa_policy) > 0, false)
      irsa_policy              = var.keda_webhooks_irsa_policy
      irsa_assume_role_enabled = var.keda_webhooks_irsa_assume_role_enabled == true && try(length(var.keda_webhooks_irsa_assume_role_arns) > 0, false)
      irsa_assume_role_arns    = var.keda_webhooks_irsa_assume_role_arns
      irsa_additional_policies = var.keda_webhooks_irsa_additional_policies
      service_account_name     = var.keda_webhooks_service_account_name
    }
  }
}

data "aws_iam_policy_document" "this_assume" {
  for_each = {
    for k, v in local.irsa_components : k => v if v.irsa_role_create && v.irsa_assume_role_enabled
  }

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = each.value.irsa_assume_role_arns
  }
}

resource "aws_iam_policy" "this" {
  for_each = {
    for k, v in local.irsa_components : k => v if v.irsa_role_create && (v.irsa_policy_enabled || v.irsa_assume_role_enabled)
  }

  name        = each.value.irsa_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path        = "/"
  description = "Policy for ${var.helm_release_name} ${each.key} component"
  policy      = each.value.irsa_assume_role_enabled ? data.aws_iam_policy_document.this_assume[each.key].json : each.value.irsa_policy

  tags = var.irsa_tags
}

data "aws_iam_policy_document" "this_irsa" {
  for_each = {
    for k, v in local.irsa_components : k => v if v.irsa_role_create
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${each.value.service_account_name}",
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = {
    for k, v in local.irsa_components : k => v if v.irsa_role_create
  }

  name               = each.value.irsa_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy = data.aws_iam_policy_document.this_irsa[each.key].json
  tags               = var.irsa_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for k, v in local.irsa_components : k => v if v.irsa_role_create && (v.irsa_policy_enabled || v.irsa_assume_role_enabled)
  }

  role       = aws_iam_role.this[each.key].name
  policy_arn = aws_iam_policy.this[each.key].arn
}

resource "aws_iam_role_policy_attachment" "this_additional" {
  for_each = merge([
    for k, v in local.irsa_components : { k = v.irsa_additional_policies } if v.irsa_role_create
  ]...)

  role       = aws_iam_role.this[each.value].name
  policy_arn = each.value
}
