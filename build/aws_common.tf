#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:49:35 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

provider "aws" {
  access_key = "${var.aws_key}"
  secret_key = "${var.aws_secret}"
  region     = "${var.aws_region}"
}

resource "aws_key_pair" "coreos" {
  key_name    = "coreos"
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7K4+mLac9yexhMY5N+XtQIbTFHxVJJLlpm4/DJw3HET25AZpy7AeBDhQwgjYHd+saPUuocxNkztmYelgXkIWhIwWn2vODt0wBryt1skNs07mVm+jPawNRrEs9q+uVVAn64P+2WmyJVgsFWOkKkrnH/sypJnLSNk8WDdpqD6JLz4fsy9+zinMh7k7Xo5UfBq78pVfUS9aVlMpOj3NmdD1UpxbIBsC+ttlVR43rqrnySK9zhzezYot4PlA1LInnw8E7o8TxnJ6z2xXx5PsNMbjLW94OjpjsbvbKsKnLunA2LMc65HtOAVdPqHTWxbMuSlKjChiWJDjujdjVID8FpW09 imported-openssh-key"
}
