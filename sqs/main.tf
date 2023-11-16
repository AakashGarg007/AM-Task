resource "aws_sqs_queue" "mainQueue" {
  name = "${var.environment}-${var.app_name}-pricing-sqs"
  tags = var.default_tags
  visibility_timeout_seconds = 900
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadLettterQueue.arn
    maxReceiveCount     = 10
  })
}

resource "aws_sqs_queue" "deadLettterQueue" {
  name = "${var.environment}-${var.app_name}-pricing-dlq"
  tags = var.default_tags
  visibility_timeout_seconds = 3600
}
