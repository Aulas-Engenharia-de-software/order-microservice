resource "aws_ecr_repository" "order_app" {
  name                 = var.ecr_config.name
  image_tag_mutability = var.ecr_config.image_tag_mutability

  force_delete = var.ecr_config.force_delete
  image_scanning_configuration {
    scan_on_push = var.ecr_config.scan_on_push
  }

  tags = var.ecr_config.tags
}

resource "aws_ecr_lifecycle_policy" "order_app_policy" {
  repository = aws_ecr_repository.order_app.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        action       = { type = "expire" }
        selection    = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 3
        }
      }
    ]
  })
}