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
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }
}


resource "aws_autoscaling_group" "coreos_scale_gruop" {
  availability_zones        = [ "eu-west-1a", "eu-west-1b" ]
  name                      = "coreos_scale_gruop"
  max_size                  = "${var.coreos_cluster_max}"
  min_size                  = "${var.coreos_cluster_min}"
  desired_capacity          = "${var.coreos_cluster_desired}"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.coreos_launch_config.name}"
  vpc_zone_identifier       = [ "subnet-83da09da", "subnet-533dab36" ]
}

resource "aws_launch_configuration" "coreos_launch_config" {
  name            = "coreos_launch_config"
  image_id        = "${lookup(var.coreos_amis, var.aws_region)}"
  instance_type   = "${var.coreos_flavor}"
  key_name        = "${aws_key_pair.coreos.key_name}"
  security_groups = [ "${aws_security_group.coreos.id}" ]
  associate_public_ip_address = "${var.coreos_public_ip}"
  user_data       =<<EOF
#cloud-config
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-16 10:24:42 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7K4+mLac9yexhMY5N+XtQIbTFHxVJJLlpm4/DJw3HET25AZpy7AeBDhQwgjYHd+saPUuocxNkztmYelgXkIWhIwWn2vODt0wBryt1skNs07mVm+jPawNRrEs9q+uVVAn64P+2WmyJVgsFWOkKkrnH/sypJnLSNk8WDdpqD6JLz4fsy9+zinMh7k7Xo5UfBq78pVfUS9aVlMpOj3NmdD1UpxbIBsC+ttlVR43rqrnySK9zhzezYot4PlA1LInnw8E7o8TxnJ6z2xXx5PsNMbjLW94OjpjsbvbKsKnLunA2LMc65HtOAVdPqHTWxbMuSlKjChiWJDjujdjVID8FpW09 imported-openssh-key
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD2TMUDqvIjPtfRsbUkqADC9Y47pWYAPGfaH5FkGijm5AtYIZI465/IHR517Ofbd+eeLrBp5VyAVUYcUyZOfLvINIYBcAMZDuzMZV3hQYiCj6whnPzq5ItAgd7KJUKYKWgAUvA0dfacM5STe7woH4Bg9L7kExs9q/1GonYynUBkOdmX6rP8SdG2kfcauvIS7YQkdUW+oymb8kge4zVd/WuqjId95wGHhkFzq/4CeqFFCd/dOjW/61yTp/E6Ms8Gd3NwNLD7l60AulMqRkxHJnMH3rAGSyhyvhLFqwpcc5/5wpaibsAW0oKwCEn/FC12WythVy+g4HAIwHKHCDRVPzqH jest@starfury

write_files:
  - path: /run/setup_environment.sh
    permissions: '0755'
    content: |
      #!/usr/bin/bash
      HOSTS_FILE=/etc/hosts
      PRIVATE_IP=$(/bin/hostname -i)
      NAME=$(/bin/hostname -f)

      add_host() {
        echo -e "$PRIVATE_IP \t$NAME" >> $HOSTS_FILE
        if [ $? -ne 0 ]; then
          echo "Failed to add the hostname to $HOSTS_FILE"
          exit 1
        fi
        exit 0
      }

      [ -f $HOSTS_FILE ] || add_host
      grep $PRIVATE_IP $HOSTS_FILE > /dev/null 2>/dev/null || add_host
  - path: /etc/ntp.conf
    content: |
      # Common pool
      server 0.europe.pool.ntp.org
      server 1.europe.pool.ntp.org

      # - Allow only time queries, at a limited rate.
      # - Allow all local queries (IPv4, IPv6)
      restrict default nomodify nopeer noquery limited kod
      restrict 127.0.0.1
      restrict [::1]

coreos:
  etcd:
    discovery: ${var.coreos_discovery_token}
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  fleet:
    public-ip: $private_ipv4
  units:
    - name: setup-environment.service
      command: start
      runtime: true
      content: |
        [Unit]
        Description=Setup environment
        Before=etcd.service

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=/run/setup_environment.sh
    - name: format-ephemeral.service
      command: start
      content: |
        [Unit]
        Description=Formats the ephemeral drive
        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=/usr/sbin/wipefs -f /dev/xvdb
        ExecStart=/usr/sbin/mkfs.btrfs -f /dev/xvdb
    - name: var-lib-docker.mount
      command: start
      content: |
        [Unit]
        Description=Mount ephemeral to /var/lib/docker
        Requires=format-ephemeral.service
        After=format-ephemeral.service
        Before=docker.service
        [Mount]
        What=/dev/xvdb
        Where=/var/lib/docker
        Type=btrfs
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
    - name: docker-tcp.socket
      command: start
      enable: true
      content: |
        [Unit]
        Description=Docker Socket for the API

        [Socket]
        ListenStream=2375
        Service=docker.service
        BindIPv6Only=both

        [Install]
        WantedBy=sockets.target
    - name: settimezone.service
      command: start
      content: |
        [Unit]
        Description=Set the timezone

        [Service]
        ExecStart=/usr/bin/timedatectl set-timezone UTC
        RemainAfterExit=yes
        Type=oneshot
EOF
}
