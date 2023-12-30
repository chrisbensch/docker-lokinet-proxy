#!/bin/sh

# Fix for no tun device
# Taken from https://github.com/kylemanna/docker-openvpn/blob/master/bin/ovpn_run
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

echo 'nameserver 127.3.2.1' > /etc/resolv.conf

/usr/local/bin/fedproxy socks 0.0.0.0:2000 0.0.0.0:9050 0.0.0.0:4447 &

/usr/bin/lokinet
