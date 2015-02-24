#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-16 13:53:12 +0000 (Mon, 16 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

variable "aws_key"      {}
variable "aws_secret"   {}
variable "aws_region" {
  default = "eu-west-1"
}

variable "vpc_id" {
  default = {
    "eu-west-1" = "vpc-d93ee5bc"
  }
}

variable "vpc_subnet" {
  default = {
    "eu-west-1a" = "subnet-83da09da"
    "eu-west-1b" = "subnet-533dab36"
    "eu-west-1c" = "subnet-79a9170e"
  }
}

# --- COREOS ----

variable "coreos_cluster_min"     {}
variable "coreos_cluster_max"     {}
variable "coreos_cluster_desired" {}
variable "coreos_discovery_token" {}
variable "coreos_flavor"          {}
variable "coreos_public_ip"       {}

variable "coreos_amis" {
  default = {
    "eu-west-1" = "ami-5b911f2c"
    "us-east-1" = "ami-8297d4ea"
  }
}
