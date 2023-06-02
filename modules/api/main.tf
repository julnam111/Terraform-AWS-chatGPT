data "aws_lambda_function" "lambda_function" {
  function_name = "lambda_function"
}

## Create API Gateway
/*resource "null_resource" "execute_cli_create_api" {
  provisioner "local-exec" {
    command = "aws apigatewayv2 create-api --name MyOpenAPI --protocol-type HTTP --target ${data.aws_lambda_function.lambda_function.arn} --cors-configuration AllowOrigins=['*'] --region us-east-1"
  }
}*/
resource "aws_apigatewayv2_api" "my_open_api" {
  name          = "MyOpenAPI"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
  }
  target = data.aws_lambda_function.lambda_function.arn
}

## Back-end integration with lambda function
/*resource "null_resource" "execute_cli_integrate_api" {
  depends_on = [null_resource.execute_cli_create_api]
  provisioner "local-exec" {
    command = "aws apigatewayv2 create-integration --api-id ${tolist(data.aws_apigatewayv2_apis.my_openapi.ids)[0]} --integration-type AWS_PROXY --integration-uri ${data.aws_lambda_function.lambda_function.arn} --payload-format-version 2.0 --region us-east-1"
  }
}*/
data "aws_apigatewayv2_apis" "my_openapi" {
  depends_on = [aws_apigatewayv2_api.my_open_api]
  name = "MyOpenAPI" 
  protocol_type = "HTTP"
}
output "api_id" {
  depends_on = [aws_apigatewayv2_api.my_open_api]
  value = tolist(data.aws_apigatewayv2_apis.my_openapi.ids)[0]
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  depends_on = [aws_apigatewayv2_api.my_open_api]
  api_id             = aws_apigatewayv2_api.my_open_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = data.aws_lambda_function.lambda_function.arn
  payload_format_version = "2.0"
}


## Add Permission to execute lambda function
data "aws_caller_identity" "current" {}
/*resource "null_resource" "execute_cli_lambda_role_add" {
  depends_on = [null_resource.execute_cli_integrate_api]
  provisioner "local-exec" {
    command = "aws lambda add-permission --function-name lambda_function --statement-id apigateway-myopenapi-permission --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${tolist(data.aws_apigatewayv2_apis.my_openapi.ids)[0]}/* --region us-east-1"
  }
}*/
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "apigateway-myopenapi-permission"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.lambda_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${tolist(data.aws_apigatewayv2_apis.my_openapi.ids)[0]}/*"
}
