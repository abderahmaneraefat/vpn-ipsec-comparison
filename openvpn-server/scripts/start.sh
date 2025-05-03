#!/bin/sh

# Créer les répertoires manquants
mkdir -p /etc/openvpn/server
mkdir -p /var/log/openvpn

# Vérifier que le fichier de config existe
CONFIG_FILE="/etc/openvpn/server/server.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERREUR: Fichier de configuration $CONFIG_FILE introuvable"
    echo "Contenu de /etc/openvpn/server :"
    ls -la /etc/openvpn/server/
    exit 1
fi

# Générer les certificats si nécessaire
if [ ! -f "/etc/openvpn/server/ca.crt" ]; then
    echo "Génération des clés OpenVPN..."

    # Créer l'environnement PKI
    mkdir -p /etc/openvpn/easy-rsa/pki
    cd /etc/openvpn

    # Générer les paramètres DH
    openssl dhparam -out server/dh.pem 2048

    # Générer CA
    openssl req -new -x509 -days 3650 \
        -keyout server/ca.key -out server/ca.crt \
        -subj "/CN=OpenVPN CA" -nodes

    # Générer certificat serveur
    openssl req -new -keyout server/server.key -out server/server.csr \
        -subj "/CN=OpenVPN Server" -nodes
    openssl x509 -req -in server/server.csr -CA server/ca.crt \
        -CAkey server/ca.key -CAcreateserial -out server/server.crt -days 3650

    # Sécuriser les permissions
    chmod 600 server/*.key
    chmod 644 server/*.crt server/*.pem
fi

echo "Démarrage du serveur OpenVPN..."
exec openvpn --config "$CONFIG_FILE" \
    --cd /etc/openvpn/server \
    --verb 3 \
    --user nobody \
    --group nobody \
    --persist-key \
    --persist-tun