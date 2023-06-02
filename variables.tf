variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = "<key>"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = "<secret>"
}

variable "region" {
  type    = string
  default = "us-east-1"
}