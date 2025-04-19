resource "aws_api_gateway_rest_api" "order" {
  name        = var.api_gateway_config.name
  description = var.api_gateway_config.description
}

resource "aws_api_gateway_resource" "orders" {
  rest_api_id = aws_api_gateway_rest_api.order.id
  parent_id   = aws_api_gateway_rest_api.order.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.order.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.order.id
  resource_id             = aws_api_gateway_resource.orders.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "HTTP"
  uri                     = "http://${aws_lb.ecs_alb.dns_name}/orders"
  connection_type         = "INTERNET"
  timeout_milliseconds    = 29000

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/json'"
    "integration.request.header.Accept" = "'application/json'"
  }

  depends_on = [
    aws_api_gateway_method.post,
    aws_api_gateway_method_response.response_200,
    aws_api_gateway_method_response.response_400
  ]
}

# Resposta de sucesso (200)
resource "aws_api_gateway_integration_response" "success" {
  rest_api_id = aws_api_gateway_rest_api.order.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Se sua API retornar texto puro em vez de JSON
  response_templates = {
    "application/json" = <<EOF
    {
      "message": "$input.path('$')"
    }
    EOF
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }

  depends_on = [aws_api_gateway_integration.integration]
}

# Resposta de erro (400)
resource "aws_api_gateway_integration_response" "bad_request" {
  rest_api_id       = aws_api_gateway_rest_api.order.id
  resource_id       = aws_api_gateway_resource.orders.id
  http_method       = aws_api_gateway_method.post.http_method
  status_code       = aws_api_gateway_method_response.response_400.status_code
  selection_pattern = "400"  # Padrão para capturar respostas 400 do backend

  response_templates = {
    "application/json" = <<EOF
    {
      "error": "$input.path('$.code')",
      "message": "$input.path('$.message')",
      "details": $input.path('$.details')
    }
    EOF
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }

  depends_on = [aws_api_gateway_integration.integration]
}

# Configuração para resposta 200
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.order.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# Configuração para resposta 400
resource "aws_api_gateway_method_response" "response_400" {
  rest_api_id = aws_api_gateway_rest_api.order.id
  resource_id = aws_api_gateway_resource.orders.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "400"

  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.order.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id   = aws_api_gateway_rest_api.order.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = aws_api_gateway_method.options.http_method
  type          = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id   = aws_api_gateway_rest_api.order.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = aws_api_gateway_method.options.http_method
  status_code   = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id   = aws_api_gateway_rest_api.order.id
  resource_id   = aws_api_gateway_resource.orders.id
  http_method   = aws_api_gateway_method.options.http_method
  status_code   = aws_api_gateway_method_response.options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.order.id
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.order.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}