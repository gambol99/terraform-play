#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:49:35 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

variable "aws_region" {
  description = "The default AWS region"
  default     = "eu-west-1"
}

variable "aws_credential" {
  description = "The AWS credentials"
  aws_key     = ""
  aws_secret  = ""
}

variable "aws_vpc_subnets" {
  default = {
    "eu-west-1" = ""
    "us-east-1" = ""
  }
}
