# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "operator_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the KEDA operator."
}

variable "operator_service_account_name" {
  type        = string
  default     = "keda-operator"
  description = "The name of the Service Account for the KEDA operator."
}

variable "operator_irsa_role_create" {
  type        = bool
  default     = false
  description = "Whether to create the IRSA role for the KEDA operator."
}

variable "operator_irsa_role_name" {
  type        = string
  default     = "keda-operator"
  description = "The name of the IRSA role for the KEDA operator."
}

variable "operator_irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `operator_irsa_policy` for the KEDA operator. Mutually exclusive with `operator_irsa_assume_role_enabled`."
}

variable "operator_irsa_policy" {
  type        = string
  default     = ""
  description = "Policy to be attached to the default role of the KEDA operator. Applied only if `operator_irsa_policy_enabled` is `true`."
}

variable "operator_irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA for the KEDA operator is allowed to assume role defined by `operator_irsa_assume_role_arn`. Mutually exclusive with `operator_irsa_policy_enabled`."
}

variable "operator_irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "Assume role ARNs for the KEDA operator. Applied only if `operator_irsa_assume_role_enabled` is `true`."
}

variable "operator_irsa_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the IRSA role of the KEDA operator. Defaults to `\"\"`."
}

variable "operator_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role of the KEDA operator. Where key is arbitrary id and value is policy ARN."
}

variable "metric_server_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the KEDA metrics server."
}

variable "metric_server_service_account_name" {
  type        = string
  default     = "keda-metrics-server"
  description = "The name of the Service Account for the KEDA metrics server."
}

variable "metric_server_irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create the IRSA role for the KEDA metrics server."
}

variable "metric_server_irsa_role_name" {
  type        = string
  default     = "keda-metrics-server"
  description = "The name of the IRSA role for the KEDA metrics server."
}

variable "metric_server_irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `metric_server_irsa_policy` for the KEDA metrics server. Mutually exclusive with `metric_server_irsa_assume_role_enabled`."
}

variable "metric_server_irsa_policy" {
  type        = string
  default     = ""
  description = "Policy to be attached to the default role of the KEDA metrics server. Applied only if `metric_server_irsa_policy_enabled` is `true`."
}

variable "metric_server_irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA for the KEDA metrics server is allowed to assume role defined by `metric_server_irsa_assume_role_arn`. Mutually exclusive with `metric_server_irsa_policy_enabled`."
}

variable "metric_server_irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "Assume role ARNs for the KEDA metrics server. Applied only if `metric_server_irsa_assume_role_enabled` is `true`."
}

variable "metric_server_irsa_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the IRSA role of the KEDA metrics server. Defaults to `\"\"`."
}

variable "metric_server_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role of the KEDA metrics server. Where key is arbitrary id and value is policy ARN."
}

variable "webhooks_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the KEDA webhooks."
}

variable "webhooks_service_account_name" {
  type        = string
  default     = "keda-webhook"
  description = "The name of the Service Account for the KEDA webhooks."
}

variable "webhooks_irsa_role_create" {
  type        = bool
  default     = false
  description = "Whether to create the IRSA role for the KEDA webhooks."
}

variable "webhooks_irsa_role_name" {
  type        = string
  default     = "keda-webhook"
  description = "The name of the IRSA role for the KEDA webhooks."
}

variable "webhooks_irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `webhooks_irsa_policy` for the KEDA operator. Mutually exclusive with `webhooks_irsa_assume_role_enabled`."
}

variable "webhooks_irsa_policy" {
  type        = string
  default     = ""
  description = "Policy to be attached to the default role of the KEDA webhooks. Applied only if `webhooks_irsa_policy_enabled` is `true`."
}

variable "webhooks_irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA for the KEDA webhooks is allowed to assume role defined by `webhooks_irsa_assume_role_arn`. Mutually exclusive with `webhooks_irsa_policy_enabled`."
}

variable "webhooks_irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "Assume role ARNs for the KEDA webhooks. Applied only if `webhooks_irsa_assume_role_enabled` is `true`."
}

variable "webhooks_irsa_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the IRSA role of the KEDA webhooks. Defaults to `\"\"`."
}

variable "webhooks_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role of the KEDA webhooks. Where key is arbitrary id and value is policy ARN."
}
