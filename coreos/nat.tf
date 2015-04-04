#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:55:48 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

#resource "aws_instance" "nat" {
#  ami               = "${lookup(var.amis, var.region)}"
#  instance_type     = "t2.micro"
#  subnet_id         = "${aws_subnet.public.id}"
#  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
#  key_name          = "${aws_key_pair.deployer.key_name}"
#  source_dest_check = false
#  tags = {
#    Name = "nat"
#  }
#
#  connection {
#    user     = "ubuntu"
#    key_file = "ssh/core"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
#      "echo 1 > /proc/sys/net/ipv4/conf/all/forwarding",
#      /* Install docker */
#      "curl -sSL https://get.docker.com/ubuntu/ | sudo sh",
#      /* Initialize open vpn data container */
#      "sudo mkdir -p /etc/openvpn",
#      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
#      /* Generate OpenVPN server config */
#      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr} -u udp://${aws_instance.nat.#public_ip}"#
#    ]#
#  }
#}
