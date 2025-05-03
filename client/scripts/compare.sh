#!/bin/sh

# Créer le dossier des résultats
mkdir -p /results

# Exécuter le script de configuration du client
echo "Exécution du script de configuration du client OpenVPN..."
sh /usr/local/bin/client_config.sh

# Test VPN
echo "Début du test VPN..."
sh /usr/local/bin/test_vpn.sh

# Test IPSec
echo "Début du test IPSec..."
sh /usr/local/bin/test_ipsec.sh

# Analyse (Python 3 requis dans l'image Docker)
echo "Génération des graphiques..."
python3 <<EOF
import json, matplotlib.pyplot as plt

with open('/results/vpn_results.json') as f:
    vpn = json.load(f)
with open('/results/ipsec_results.json') as f:
    ipsec = json.load(f)

metrics = {
    'Débit (Mbps)': [
        vpn['end']['sum_received']['bits_per_second']/1e6,
        ipsec['end']['sum_received']['bits_per_second']/1e6
    ],
    'Latence (ms)': [
        vpn['end']['sum']['rtt']*1000,
        ipsec['end']['sum']['rtt']*1000
    ]
}

for metric, values in metrics.items():
    plt.figure()
    plt.bar(['OpenVPN', 'IPSec'], values)
    plt.title(f'Comparaison {metric}')
    plt.ylabel(metric)
    plt.savefig(f'/results/{metric.replace(" ", "_")}.png')

EOF

echo "Résultats sauvegardés dans /results/"
