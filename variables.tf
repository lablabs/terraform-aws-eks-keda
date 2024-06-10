# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "keda_operator_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the KEDA operator."
}

variable "keda_operator_service_account_name" {
  type        = string
  default     = "keda-operator"
  description = "The name of the Service Account for the KEDA operator."
}

variable "keda_operator_irsa_role_create" {
  type        = bool
  default     = false
  description = "Whether to create the IRSA role for the KEDA operator."
}

variable "keda_operator_irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `keda_operator_irsa_policy` for the KEDA operator. Mutually exclusive with `keda_operator_irsa_assume_role_enabled`."
}

variable "keda_operator_irsa_policy" {
  type        = string
  default     = ""
  description = "Policy to be attached to the default role of the KEDA operator. Applied only if `keda_operator_irsa_policy_enabled` is `true`."
}

variable "keda_operator_irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA for the KEDA operator is allowed to assume role defined by `keda_operator_irsa_assume_role_arn`. Mutually exclusive with `keda_operator_irsa_policy_enabled`."
}

variable "keda_operator_irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "Assume role ARNs for the KEDA operator. Applied only if `keda_operator_irsa_assume_role_enabled` is `true`."
}

variable "keda_operator_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role of the KEDA operator. Where key is arbitrary id and value is policy ARN."
}

variable "keda_metric_server_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the KEDA metrics server."
}

variable "keda_metric_server_service_account_name" {
  type        = string
  default     = "keda-metrics-server"
  description = "The name of the Service Account for the KEDA metrics server."
}

variable "keda_metric_server_irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create the IRSA role for the KEDA metrics server."
}

variable "keda_metric_server_irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `keda_metric_server_irsa_policy` for the KEDA metrics server. Mutually exclusive with `keda_metric_server_irsa_assume_role_enabled`."
}

variable "keda_metric_server_irsa_policy" {
  type        = string
  default     = ""
  description = "Policy to be attached to the default role of the KEDA metrics server. Applied only if `keda_metric_server_irsa_policy_enabled` is `true`."
}

variable "keda_metric_server_irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA for the KEDA metrics server is allowed to assume role defined by `keda_metric_server_irsa_assume_role_arn`. Mutually exclusive with `keda_metric_server_irsa_policy_enabled`."
}

variable "keda_metric_server_irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "Assume role ARNs for the KEDA metrics server. Applied only if `keda_metric_server_irsa_assume_role_enabled` is `true`."
}

variable "keda_metric_server_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role of the KEDA metrics server. Where key is arbitrary id and value is policy ARN."
}

variable "keda_webhooks_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the KEDA webhooks."
}

variable "keda_webhooks_service_account_name" {
  type        = string
  default     = "keda-webhook"
  description = "The name of the Service Account for the KEDA webhooks."
}

variable "keda_webhooks_irsa_role_create" {
  type        = bool
  default     = false
  description = "Whether to create the IRSA role for the KEDA webhooks."
}

variable "keda_webhooks_irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `keda_webhooks_irsa_policy` for the KEDA operator. Mutually exclusive with `keda_webhooks_irsa_assume_role_enabled`."
}

variable "keda_webhooks_irsa_policy" {
  type        = string
  default     = ""
  description = "Policy to be attached to the default role of the KEDA webhooks. Applied only if `keda_webhooks_irsa_policy_enabled` is `true`."
}

variable "keda_webhooks_irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA for the KEDA webhooks is allowed to assume role defined by `keda_webhooks_irsa_assume_role_arn`. Mutually exclusive with `keda_webhooks_irsa_policy_enabled`."
}

variable "keda_webhooks_irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "Assume role ARNs for the KEDA webhooks. Applied only if `keda_webhooks_irsa_assume_role_enabled` is `true`."
}

variable "keda_webhooks_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to default role of the KEDA webhooks. Where key is arbitrary id and value is policy ARN."
}
