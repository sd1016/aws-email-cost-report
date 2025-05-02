output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.send_email.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.send_email.arn
}

output "event_rule_name" {
  description = "The name of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.daily_lambda_trigger.name
}

output "iam_role_name" {
  description = "The name of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.arn
}
