locals {
  task_environment_vars = [
    {
      name  = "AWS_REGION",
      value = var.region
    },
    {
      name  = "SNS_TOPIC_ARN",
      value = aws_sns_topic.order.arn
    }
  ]
}