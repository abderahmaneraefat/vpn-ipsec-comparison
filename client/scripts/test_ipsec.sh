#!/bin/sh

echo "Testing IPSec connection..."
ipsec start
ipsec up myvpn

sleep 5

iperf3 -c 10.10.10.1 -t 30 -J > /results/ipsec_results.json

ipsec down myvpn