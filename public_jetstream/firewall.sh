#!/bin/bash

# Create final config from template
envsubst < /etc/nats/nats.conf > /etc/nats/nats.conf

# Apply firewall rules if needed
if [ "${APPLY_FIREWALL}" = "yes" ]; then
  iptables -A INPUT -p tcp -s ${PRIVATE_JETSTREAM_IP} --dport ${CLIENT_PORT} -j ACCEPT
  iptables -A INPUT -p tcp ! -s ${PRIVATE_JETSTREAM_IP} --dport ${CLIENT_PORT} -j DROP
fi

# Start NATS server with arguments passed to the script
exec nats-server -c /etc/nats/nats.conf "$@"
