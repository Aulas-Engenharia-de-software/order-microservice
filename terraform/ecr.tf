resource "aws_ecr_repository" "order_app" {
  name                 = local.ecr_image_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags                 = {
    Name = "order-app"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "order_app_policy" {
  repository = local.ecr_image_name
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