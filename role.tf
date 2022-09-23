resource "aws_iam_policy" "lambda_execute_role_policy" {
  name        = "schedule-start-stop-resource-role-policy"
  description = "Policy for lambda"
  policy      = file("./role_policy/lambda_execute_role_policy.json")
}

resource "aws_iam_role" "labmda_role" {
  name               = "schedule-start-stop-resource-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execute_role_policy_attachment" {
  role       = aws_iam_role.labmda_role.name
  policy_arn = aws_iam_policy.lambda_execute_role_policy.arn
}