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

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "api"
  output_path = "api.zip"
}


resource "aws_lambda_function" "api" {
  depends_on       = [aws_iam_role.lambda_role]
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "fannaly-${var.env}-api"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.lambda_handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# Amazon API Gateway
