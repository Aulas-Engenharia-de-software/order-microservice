output "ecs_service_url" {
  value = "http://${aws_lb.ecs_alb.dns_name}"
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}orders"
}