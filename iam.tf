locals {
  irsa_role_create               = var.enabled && var.service_account_create && var.irsa_role_create
  irsa_policy_allow_assume_roles = length(var.irsa_policy_allow_assume_roles) > 0 ? var.irsa_policy_allow_assume_roles : ["arn:aws:iam::${data.aws_caller_identity.this.id}:role/*"]
}

data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "this" {
  count = local.irsa_role_create && var.irsa_policy_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = local.irsa_policy_allow_assume_roles
  }
}

resource "aws_iam_policy" "this" {
  count       = local.irsa_role_create && var.irsa_policy_enabled ? 1 : 0
  name        = "${var.irsa_role_name_prefix}-${var.helm_release_name}"
  path        = "/"
  description = "Policy for keda service"

  policy = data.aws_iam_policy_document.this[0].json
  tags   = var.irsa_tags
}

data "aws_iam_policy_document" "this_assume" {
  count = local.irsa_role_create ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "this" {
  count = local.irsa_role_create ? 1 : 0

  name               = "${var.irsa_role_name_prefix}-${var.helm_release_name}"
  assume_role_policy = data.aws_iam_policy_document.this_assume[0].json

  tags = var.irsa_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.irsa_role_create ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = local.irsa_role_create ? var.irsa_additional_policies : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
