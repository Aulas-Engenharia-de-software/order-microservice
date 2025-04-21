resource "aws_ecs_cluster" "ecs_cluster" {
  name = local.ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_task_definition" "inventory_task_definition" {
  family                   = local.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = [local.provider]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.sns_task_role.arn

  container_definitions = jsonencode([
    {
      name             = local.container_name,
      image            = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.ecr_image_name}:latest",
      essential        = true,
      portMappings     = local.ports
      environment      = local.task_environment_vars,
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-group"         = local.awslogs-group_name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "order" {
  name            = local.ecs_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.inventory_task_definition.arn
  desired_count   = 0

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = local.container_name
    container_port   = 8080
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100

  capacity_provider_strategy {
    capacity_provider = local.provider
    weight            = 1
  }
}


resource "aws_iam_role" "scheduler_role" {
  name = "scheduler-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = { Service = "scheduler.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "scheduler_policy" {
  name = "scheduler-policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecs:UpdateService"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_scheduler_schedule" "start_producer" {
  name                = var.schedulers_config.start_schedule.name
  schedule_expression = var.schedulers_config.start_schedule.expression
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      Service      = aws_ecs_service.order.name,
      Cluster      = aws_ecs_cluster.ecs_cluster.name,
      DesiredCount = var.schedulers_config.start_schedule.desired_count
    })
  }
}

resource "aws_scheduler_schedule" "stop_producer" {
  name                = var.schedulers_config.stop_schedule.name
  schedule_expression = var.schedulers_config.stop_schedule.expression
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      Service      = aws_ecs_service.order.name,
      Cluster      = aws_ecs_cluster.ecs_cluster.name,
      DesiredCount = var.schedulers_config.stop_schedule.desired_count
    })
  }
}

resource "aws_cloudwatch_log_group" "order_service" {
  name              = "/ecs/${local.ecs_service_name}"
  retention_in_days = 3
}