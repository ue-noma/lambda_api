# IAM for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "AWSLambdaBasicExecutionRoleForFannaly"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name   = "AWSLambdaBasicExecutionRoleForFannaly"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_execution_role.json
}

data "aws_iam_policy_document" "lambda_execution_role" {

  statement {
    actions = ["logs:CreateLogGroup"]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/fannaly-${var.env}:*"
    ]
  }

}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM for API Gateway

# AWS Lambda

# Amazon API Gateway
