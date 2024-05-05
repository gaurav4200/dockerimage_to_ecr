provider "aws" {
  region = "YOUR_REGION"
}

resource "aws_lambda_function" "my_lambda" {
  function_name    = "my-docker-lambda"
  role             = aws_iam_role.lambda_role.arn
  package_type     = "Image"
  image_uri        = "YOUR_AWS_ACCOUNT_ID.dkr.ecr.YOUR_REGION.amazonaws.com/my-docker-image:latest"
  timeout          = 30
  memory_size      = 512
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_permissions" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_glue_permissions" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "lambda_rds_permissions" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}