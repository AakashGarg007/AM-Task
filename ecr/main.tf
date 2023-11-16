resource "aws_ecr_repository" "app" {
  name                 = var.repo_name
  image_tag_mutability = var.tag_mutability

  image_scanning_configuration {
    scan_on_push = var.should_scan_on_push
  }

  tags = var.default_tags
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.app.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Delete untagged images when image count breaches 5",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}