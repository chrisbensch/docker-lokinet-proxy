#!/bin/sh

echo 'nameserver 127.3.2.1' > /etc/resolv.conf

screen -dmS lokinet /lokinet/build/daemon/lokinet
screen -dmS fedproxy /usr/local/bin/fedproxy socks 127.0.0.1:2000 127.0.0.1:9050 127.0.0.1:4447