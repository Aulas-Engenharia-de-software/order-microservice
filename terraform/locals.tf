locals {
  ecs_cluster_name   = "event_driven-cluster"
  ecs_service_name   = "order-service"
  ecr_image_name     = "order-app"
  task_family        = "${local.ecs_service_name}-task-family"
  api_gateway_name   = "${local.ecs_service_name}-api"
  container_name     = "${local.ecs_service_name}-container"
  awslogs-group_name = "/ecs/${local.ecs_service_name}-logs"
  sns_name           = "order-created-topic"
  sqs_name           = "order-created-queue"
  provider           = "FARGATE"
  ports              = [
    {
      containerPort = 8080,
      hostPort      = 8080
    }
  ]

  task_environment_vars = [
    {
      name  = "AWS_REGION",
      value = var.region
    },
    {
      name  = "SNS_TOPIC_ARN",
      value = aws_sns_topic.sns_topic_order_created.arn
    }
  ]
}