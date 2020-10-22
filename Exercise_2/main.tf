provider "aws" {
	region  = var.aws_region
	profile = "443t"
}

data "archive_file" "lambda_zip" {
	type        = "zip"
	source_file = "greet_lambda.py"
	output_path = "greet_lambda.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
	filename      = data.archive_file.lambda_zip.output_path
	function_name = "greet_lambda"
	role 	      = aws_iam_role.iam_for_lambda.arn
	handler       = "greet_lambda.lambda_handler"
	runtime       = "python3.8"

	environment {
		variables = {
			greeting = "Hello"
		}
	}

	depends_on = [
	    aws_iam_role_policy_attachment.lambda_logs
	]	
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
