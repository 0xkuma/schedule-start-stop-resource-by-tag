resource "aws_cloudwatch_event_rule" "schedule_start_resource_rule" {
  name                = "schedule-start-resource"
  description         = "EventBridge Rule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_rule" "schedule_stop_resource_rule" {
  name                = "schedule-stop-resource"
  description         = "EventBridge Rule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "schedule_start_resource_target" {
  rule      = aws_cloudwatch_event_rule.schedule_start_resource_rule.name
  target_id = "schedule-start-resource"
  arn       = aws_lambda_function.schedule_start_stop_resource.arn
  input = jsonencode({
    "job" = "start"
  })
}

resource "aws_cloudwatch_event_target" "schedule_stop_resource_target" {
  rule      = aws_cloudwatch_event_rule.schedule_stop_resource_rule.name
  target_id = "schedule_stop-resource"
  arn       = aws_lambda_function.schedule_start_stop_resource.arn
  input = jsonencode({
    "job" = "stot"
  })
}