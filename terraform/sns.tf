resource "aws_sns_topic" "sns_topic_order_created" {
  name              = local.sns_name
  display_name      = "Order Created Notifications"
  kms_master_key_id = "alias/aws/sns"

}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns_topic_order_created.arn
  protocol  = "email"
  endpoint  = "lucasrodriguesmartins007@gmail.com"
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.sns_topic_order_created.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_created.arn
}