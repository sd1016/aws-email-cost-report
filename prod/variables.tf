variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}


variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "sd1016_email_cost_report"
}


variable "sender_email" {
  description = "The email address of the sender"
  type        = string
  default     = "example1@gmail.com"
}

variable "recipient_email" {
  description = "The email address of the recipient"
  type        = string
  default     = "example2@gmail.com"
}

variable "iam_role_name" {
  description = "The name of the IAM role for Lambda"
  type        = string
  default     = "sd1016_lambda_role"
}

variable "ses_policy_name" {
  description = "The name of the SES policy"
  type        = string
  default     = "sd1016_ses_policy"
}

variable "log_group_policy_name" {
  description = "The name of the CloudWatch log group policy"
  type        = string
  default     = "sd1016_log_group_policy"
}

variable "event_rule_name" {
  description = "The name of the EventBridge rule"
  type        = string
  default     = "sd1016_daily_lambda_trigger"
}

variable "cost_usage_policy_name" {
  description = "The name of the Cost and Usage policy"
  type        = string
  default     = "sd1016_cost_usage_policy"
}

