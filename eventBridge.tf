resource "aws_cloudwatch_event_rule" "schedule_start_resource" {
  name                = "schedule-start-resource"
  description         = "EventBridge Rule"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "eventBridgeTarget" {
  rule      = aws_cloudwatch_event_rule.schedule_start_resource.name
  target_id = "schedule-start-resource"
  arn       = aws_lambda_function.schedule_start_stop_resource.arn
  input = jsonencode({
    "job" = "start"
  })
}