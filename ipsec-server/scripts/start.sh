#!/bin/sh

# Vérification de la configuration
if ! grep -q "conn " /etc/ipsec.conf; then
    echo "ERREUR: Fichier de configuration invalide"
    exit 1
fi

# Création des répertoires
mkdir -p /etc/ipsec.d/{private,cacerts,certs,policies}

# Génération des clés
if [ ! -f "/etc/ipsec.d/private/ca.key" ]; then
    echo "Génération des clés IPSec..."
    ipsec pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/ca.key
    ipsec pki --self --ca --lifetime 3650 --in /etc/ipsec.d/private/ca.key \
        --type rsa --dn "CN=IPSec CA" --outform pem > /etc/ipsec.d/cacerts/ca.crt

    ipsec pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/server.key
    ipsec pki --pub --in /etc/ipsec.d/private/server.key --type rsa | \
        ipsec pki --issue --lifetime 3650 \
        --cacert /etc/ipsec.d/cacerts/ca.crt \
        --cakey /etc/ipsec.d/private/ca.key \
        --dn "CN=IPSec Server" --san "${SERVER_IP:-192.168.1.200}" \
        --flag serverAuth --outform pem > /etc/ipsec.d/certs/server.crt

    chmod 600 /etc/ipsec.d/private/*
    chmod 644 /etc/ipsec.d/cacerts/* /etc/ipsec.d/certs/*
fi

echo "Vérification de la configuration..."
ipsec listall >/dev/null || {
    echo "ERREUR: Configuration IPSec invalide"
    ipsec listall
    exit 1
}

echo "Démarrage du serveur IPSec..."
exec ipsec start --nofork --debug-all