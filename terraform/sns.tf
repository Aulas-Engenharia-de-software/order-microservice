resource "aws_sns_topic" "order" {
  name              = "order-created-topic"
  display_name      = "Order Created Notifications"
  kms_master_key_id = "alias/aws/sns"  # Criptografia padrão

}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.order.arn
  protocol  = "email"
  endpoint  = "lucasrodriguesmartins007@gmail.com"
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn = aws_sns_topic.order.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_created.arn
}