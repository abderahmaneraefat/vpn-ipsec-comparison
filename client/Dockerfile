FROM alpine:latest

RUN apk add --no-cache \
    openvpn \
    strongswan \
    iperf3 \
    tcpdump \
    curl

COPY scripts/test_vpn.sh /usr/local/bin/
COPY scripts/test_ipsec.sh /usr/local/bin/
COPY scripts/compare.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*.sh

WORKDIR /app

CMD ["/bin/sh"]