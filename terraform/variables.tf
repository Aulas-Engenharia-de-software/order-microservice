variable "ecs_config" {
  default = {
    cluster_name = "event-driven-cluster"
    service_name = "order-service"
    task_family  = "order-service-task"
    cpu          = 256
    memory       = 512
    provider     = "FARGATE"
    ports        = [
      {
        containerPort = 8080,
        hostPort      = 8080
      }
    ]
    logConfiguration = {
      logDriver = "awslogs",
      options   = {
        "awslogs-group"         = "/ecs/order-service",
        "awslogs-region"        = "us-east-1",
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }
}

variable "schedulers_config" {
  default = {
    start_schedule ={
      name = "start_scheduler"
      expression = "cron(0 19 ? * MON,TUE,THU *)"
      desired_count = 1
    }
    stop_schedule ={
      name = "stop_scheduler"
      expression = "cron(0 20 ? * MON,TUE,THU *)"
      desired_count = 0
    }
  }
}

variable "app_name" {
  default = "order-service"
}

variable "aws_account_id" {
  default = "624676054102"
}

variable "region" {
  default = "us-east-1"
}

variable "api_gateway_config" {
  default = {
    name        = "order-api",
    description = "API para processamento de pedidos"
  }
}

variable "ecr_config" {
  default = {
    name                 = "order-app"
    image_tag_mutability = "MUTABLE"
    force_delete         = true
    scan_on_push         = true
    tags                 = {
      Name = "order-app"
    }
  }
}

variable "sns_name" {
  default = "order-created-topic"
}