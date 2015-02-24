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
    "eu-west-1" = "vpc-afe333ca"
  }
}

variable "vpc_subnet" {
  default = {
    "eu-west-1" = "subnet-eafb31b3"
  }
}

# --- COREOS ----

variable "coreos_cluster_size"    {}
variable "coreos_discovery_token" {}
variable "coreos_flavor"          {}
variable "coreos_public_ip"       {}

variable "coreos_amis" {
  default = {
    "eu-west-1" = "ami-5d911f2a"
    "us-east-1" = "ami-8297d4ea"
  }
}
