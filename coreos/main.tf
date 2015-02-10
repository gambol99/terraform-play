#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-10 12:55:48 +0000 (Tue, 10 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

module "aws" {
  source = "../aws"
}

module "environment" {
  source = "../environment"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "coreos" {
  name        = "coreos"
  description = "The default security group for coreos boxes"
}

#resource "aws_instance" "coreos" {
#  connection {
#    user     = "${lookup(var.coreos_cluster.ssh,"username"}"
#    key_file = "${lookup(var.coreos_cluster.ssh,"keyfile"}"
#  }
#  key_name        = "default"
#  count           = "${var.coreos_cluster.size}"
#  instance_type   = "${var.coreos_cluster.flavor}"
#  ami             = "${lookup(var.aws_amis, var.aws_region)}"
#  security_groups = ["${aws_security_group.coreos.name}"]
#  subnet_id       = "${lookup(var.aws_subnets, var.aws_region)}"
#  tags {
#    Name = "cores${count.index + 100}"
#  }
#  user_data       = <<EOF
##cloud-config
##
##   Author: Rohith (gambol99@gmail.com)
##   Date: 2014-10-16 10:24:42 +0100 (Thu, 16 Oct 2014)
##
##  vim:ts=2:sw=2:et
##
#hostname: core${count.index + 100}.${var.domain}
#
#ssh_authorized_keys:
#  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD2TMUDqvIjPtfRsbUkqADC9Y47pWYAPGfaH5FkGijm5AtYIZI465/IHR517Ofbd+eeLrBp5VyAVUYcUyZOfLvINIYBcAMZDuzMZV3hQYiCj6whnPzq5ItAgd7KJUKYKWgAUvA0dfacM5STe7woH4Bg9L7kExs9q/1GonYynUBkOdmX6rP8SdG2kfcauvIS7YQkdUW+oymb8kge4zVd/WuqjId95wGHhkFzq/4CeqFFCd/dOjW/61yTp/E6Ms8Gd3NwNLD7l60AulMqRkxHJnMH3rAGSyhyvhLFqwpcc5/5wpaibsAW0oKwCEn/FC12WythVy+g4HAIwHKHCDRVPzqH jest@starfury
#
#write_files:
#  - path: /etc/hosts
#    permissions: 0644
#    owner: root
#    content: |
#      127.0.0.1       localhost.${var.domain} localhost
#      $private_ipv4   core${count.index + 100}.${var.domain} core${count.index + 100}
#  - path: /etc/ntp.conf
#    content: |
#      # Common pool
#      server 0.europe.pool.ntp.org
#      server 1.europe.pool.ntp.org
#
#      # - Allow only time queries, at a limited rate.
#      # - Allow all local queries (IPv4, IPv6)
#      restrict default nomodify nopeer noquery limited kod
#      restrict 127.0.0.1
#      restrict [::1]
#
#coreos:
#  etcd:
#    discovery: ${var.coreos_cluster.discovery}
#    addr: $private_ipv4:4001
#    peer-addr: $private_ipv4:7001
#  fleet:
#    public-ip: $private_ipv4
#  units:
#    - name: format-ephemeral.service
#      command: start
#      content: |
#        [Unit]
#        Description=Formats the ephemeral drive
#        [Service]
#        Type=oneshot
#        RemainAfterExit=yes
#        ExecStart=/usr/sbin/wipefs -f /dev/xvdb
#        ExecStart=/usr/sbin/mkfs.btrfs -f /dev/xvdb
#    - name: var-lib-docker.mount
#      command: start
#      content: |
#        [Unit]
#        Description=Mount ephemeral to /var/lib/docker
#        Requires=format-ephemeral.service
#        After=format-ephemeral.service
#        Before=docker.service
#        [Mount]
#        What=/dev/xvdb
#        Where=/var/lib/docker
#        Type=btrfs
#    - name: etcd.service
#      command: start
#    - name: fleet.service
#      command: start
#    - name: docker-tcp.socket
#      command: start
#      enable: true
#      content: |
#        [Unit]
#        Description=Docker Socket for the API
#
#        [Socket]
#        ListenStream=2375
#        Service=docker.service
#        BindIPv6Only=both
#
#        [Install]
#        WantedBy=sockets.target
#    - name: settimezone.service
#      command: start
#      content: |
#        [Unit]
#        Description=Set the timezone
#
#        [Service]
#        ExecStart=/usr/bin/timedatectl set-timezone UTC
#        RemainAfterExit=yes
#        Type=oneshot
#EOF
#}

