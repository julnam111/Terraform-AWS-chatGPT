## main code

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "database" {
  source = "./modules/database"
}

module "lambda" {
  source = "./modules/lambda"
  depends_on = [module.database]
}

module "api" {
   source = "./modules/api"
   depends_on = [module.lambda]
}

/*output "api_id" {
  value = "[*] api_id: ${module.api.api_id}"
}
*/




