FROM alpine:latest

# Installer les dépendances nécessaires
RUN apk add --no-cache \
    openvpn \
    easy-rsa \
    openssl \
    bash \
    iptables \
    && rm -rf /var/cache/apk/*

# Créer la structure de répertoires
RUN mkdir -p \
    /etc/openvpn/server \
    /etc/openvpn/client \
    /var/log/openvpn \
    /etc/openvpn/pki \
    /tmp/openvpn

# Copier les fichiers de configuration
COPY config/server.conf /etc/openvpn/server/
COPY scripts/start.sh /usr/local/bin/

# Définir les permissions
RUN chmod +x /usr/local/bin/*.sh && \
    chmod 644 /etc/openvpn/server/server.conf && \
    chown -R nobody:nobody /etc/openvpn /var/log/openvpn

# Configurer les volumes persistants
VOLUME ["/etc/openvpn/pki", "/etc/openvpn/client"]

# Exposer le port UDP
EXPOSE 1194/udp

# Définir l'utilisateur non-privilégié
USER nobody

# Point d'entrée
CMD ["/usr/local/bin/start.sh"]