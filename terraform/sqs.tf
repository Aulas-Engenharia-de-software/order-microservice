resource "aws_sqs_queue" "order_created" {
  name                      = "order-created-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  sqs_managed_sse_enabled = true
  tags = {
    Environment = "dev"
    Service     = "orders"
  }
}