#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:55:48 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

module "aws" {
  source     = ".."

  aws_region = "eu-west-1"
}

resource "aws_security_group" "coreos" {
  name        = "coreos"
  description = "The default security group for coreos boxes"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

