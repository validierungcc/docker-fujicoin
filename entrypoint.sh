#!/bin/bash

set -meuo pipefail

FUJICOIN_DIR=/fuji/.fujicoin/
FUJICOIN_CONF=/fuji/.fujicoin/fujicoin.conf

if [ -z "${FUJICOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  FUJICOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${FUJICOIN_CONF}" ]; then
  tee -a >${FUJICOIN_CONF} <<EOF
server=1
rpcuser=${FUJICOIN_RPCUSER:-fujicoinrpc}
rpcpassword=${FUJICOIN_RPCPASSWORD}
rpcclienttimeout=${FUJICOIN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${FUJICOIN_CONF}"
fi

if [ $# -eq 0 ]; then
  /fuji/fujicoin/src/fujicoind -rpcbind=0.0.0.0 -rpcport=8048 -rpcallowip=0.0.0.0/0 -printtoconsole=1
else
  exec "$@"
fi
