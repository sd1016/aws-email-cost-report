provider "aws" {
  region = var.aws_region
}


resource "aws_lambda_function" "send_email" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.8"
  handler          = "email_seven_days_cost.lambda_handler" # Updated handler
  filename         = "email_seven_days_cost.zip"            # Updated file name
  source_code_hash = filebase64sha256("email_seven_days_cost.zip")
  timeout          = 30

  environment {
    variables = {
      SENDER_EMAIL    = var.sender_email
      RECIPIENT_EMAIL = var.recipient_email
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "ses_policy" {
  name        = var.ses_policy_name
  description = "Allow Lambda to send email via SES"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "ses:SendEmail",
      Resource = "*"
    }]
  })
}

resource "aws_iam_policy" "log_group_policy" {
  name        = var.log_group_policy_name
  description = "Allow Lambda to create and write to CloudWatch log groups"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:${var.aws_region}:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/${var.lambda_function_name}:*"
      }
    ]
  })
}

resource "aws_iam_policy" "cost_usage_policy" {
  name        = var.cost_usage_policy_name
  description = "Allow Lambda to retrieve cost and usage data"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ce:GetCostAndUsage",
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_log_group_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.log_group_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ses_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ses_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_cost_usage_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cost_usage_policy.arn
}


resource "aws_cloudwatch_event_rule" "daily_lambda_trigger" {
  name                = var.event_rule_name
  description         = "Triggers Lambda function every day"
  schedule_expression = "cron(0 3 * * ? *)" # Runs at 03:00 UTC daily
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_lambda_trigger.name
  target_id = var.lambda_function_name
  arn       = aws_lambda_function.send_email.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_lambda_trigger.arn
}
