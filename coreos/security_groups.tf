#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:55:48 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

resource "aws_security_group" "coreos" {
  name        = "coreos"
  description = "The default security group for coreos boxes"
  vpc_id      = "${lookup(var.vpc_id, var.aws_region)}"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags {
    Name = "coreos_security"
  }
}
