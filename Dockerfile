FROM debian:stable-slim
ENV container docker
# set up packages
RUN /bin/bash -c 'echo "man-db man-db/auto-update boolean false" | debconf-set-selections'
RUN /bin/bash -c 'apt-get -o=Dpkg::Use-Pty=0 -q update && apt-get -o=Dpkg::Use-Pty=0 -q dist-upgrade -y && apt-get -o=Dpkg::Use-Pty=0 -q install -y --no-install-recommends ca-certificates curl iptables dnsutils lsb-release systemd systemd-sysv cron conntrack iproute2 python3-pip wget git golang'
RUN /bin/bash -c 'curl -so /etc/apt/trusted.gpg.d/lokinet.gpg https://deb.oxen.io/pub.gpg'
RUN /bin/bash -c 'echo "deb https://deb.oxen.io $(lsb_release -sc) main" > /etc/apt/sources.list.d/lokinet.list'
RUN /bin/bash -c 'apt-get -o=Dpkg::Use-Pty=0 -q update && apt-get -o=Dpkg::Use-Pty=0 -q dist-upgrade -y && apt-get -o=Dpkg::Use-Pty=0 -q install -y --no-install-recommends lokinet'

# make config dir for lokinet
RUN /bin/bash -c 'mkdir -p /var/lib/lokinet/conf.d'
# set up private data dir for lokinet
RUN /bin/bash -c 'mkdir /data && chown _lokinet:_loki /data'

# print lokinet util
COPY print-lokinet-address.sh /usr/local/bin/print-lokinet-address.sh
RUN /bin/bash -c 'chmod 700 /usr/local/bin/print-lokinet-address.sh'

# dns
COPY lokinet.resolveconf.txt /etc/resolv.conf
RUN /bin/bash -c 'chmod 644 /etc/resolv.conf'

# Add fedproxy to make a proxy for Lokinet
RUN go get -u github.com/majestrate/fedproxy && \
  cp /root/go/bin/fedproxy /usr/local/bin/

#RUN which lokinet

COPY start.sh /usr/local/bin/start-new.sh
RUN chmod +x /usr/local/bin/start-new.sh


STOPSIGNAL SIGRTMIN+3
#ENTRYPOINT ["/sbin/init", "verbose", "systemd.unified_cgroup_hierarchy=0", "systemd.legacy_systemd_cgroup_controller=0"]
ENTRYPOINT ["/usr/local/bin/start-new.sh"]
