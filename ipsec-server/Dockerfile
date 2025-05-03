FROM alpine:latest

RUN apk add --no-cache strongswan && \
    mkdir -p /etc/ipsec.d/{private,cacerts,certs,policies} && \
    echo -e "charon {\n  load_modular = yes\n  plugins {\n    include strongswan.conf\n  }\n}" > /etc/strongswan.conf && \
    touch /etc/strongswan.d/charon.conf && \
    chmod -R 755 /etc/ipsec.d

COPY config/ipsec.conf /etc/
COPY config/ipsec.secrets /etc/
COPY scripts/start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/start.sh && \
    chmod 644 /etc/ipsec.conf /etc/strongswan.conf

VOLUME ["/etc/ipsec.d"]

EXPOSE 500/udp 4500/udp

CMD ["/bin/sh", "/usr/local/bin/start.sh"]