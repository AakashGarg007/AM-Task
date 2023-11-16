variable "repo_name" {
  type = string
}

variable "tag_mutability" {
  type = string
}

variable "should_scan_on_push" {
  type = bool
}

variable "default_tags" {
  type = map
}

output "ecr_arn" {
  value = aws_ecr_repository.app.arn
}

output "ecr_name" {
  value = aws_ecr_repository.app.name
}

output "ecr_url" {
  value = aws_ecr_repository.app.repository_url
}
