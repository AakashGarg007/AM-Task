variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "default_tags" {
  type = map
}
output "main_queue_arn" {
  value = aws_sqs_queue.mainQueue.arn
}
output "dlq_name" {
  value = aws_sqs_queue.deadLettterQueue.name
}