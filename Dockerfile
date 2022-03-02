FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt -y dist-upgrade \
  && apt -y install build-essential cmake git libcap-dev pkg-config automake libtool libuv1-dev libsodium-dev libzmq3-dev libcurl4-openssl-dev libevent-dev nettle-dev libunbound-dev libsqlite3-dev libssl-dev libcap2-bin dialog golang screen

RUN go get -u github.com/majestrate/fedproxy \
  && cp /root/go/bin/fedproxy /usr/local/bin/

RUN git clone --recursive https://github.com/oxen-io/lokinet
WORKDIR /lokinet
RUN mkdir build
WORKDIR /lokinet/build

RUN cmake .. -DBUILD_STATIC_DEPS=OFF -DBUILD_SHARED_LIBS=ON -DSTATIC_LINK=OFF
RUN make -j$(nproc)

WORKDIR /lokinet/build/daemon
RUN chmod +x lokinet lokinet-bootstrap lokinet-vpn
RUN mkdir /var/lib/lokinet
COPY lokinet.ini /var/lib/lokinet/lokinet.ini

RUN /lokinet/build/daemon/lokinet-bootstrap

COPY start.sh /lokinet/build/daemon/start.sh
RUN chmod +x start.sh

ENTRYPOINT ["/lokinet/build/daemon/start.sh"]
