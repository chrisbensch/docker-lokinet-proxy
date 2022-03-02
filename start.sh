#!/bin/sh

echo 'nameserver 127.3.2.1' > /etc/resolv.conf

/usr/local/bin/fedproxy socks 0.0.0.0:2000 0.0.0.0:9050 0.0.0.0:4447 &
/lokinet/build/daemon/lokinet
