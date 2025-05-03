#!/bin/sh

echo "Testing OpenVPN connection..."
openvpn --config /etc/openvpn/client/client.ovpn &

sleep 5

iperf3 -c 10.8.0.1 -t 30 -J > /results/vpn_results.json

pkill openvpn