#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:55:55 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

variable "coreos_amis" {
  default = {
    "eu-west-1" = "ami-7e5d3d16"
    "us-east-1" = "ami-3e750856"
  }
}

variable "coreos_cluster" {
  ssh = {
    "username" = "core"
    "keyfile"  = "$HOME/.ssh/id_rsa.pub"
  }

  ssh_keyfile  = ""
  flavor       = "m1.small"
  discovery    = "c2f0005f6abd89f7e6380fdd525a1924"
  count        = 3
}
