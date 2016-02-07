#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

EXPECTEDARGS=2
if [ $# -lt $EXPECTEDARGS ]; then
  echo "Usage: $0 <DOMAIN> <EMAIL>"
  exit 1
fi

DOMAIN=$1
EMAIL=$2
DATA_VOL_CONT=letsencrypt-data

# renew cert
docker run \
  --rm \
  --volumes-from $DATA_VOL_CONT \
  quay.io/letsencrypt/letsencrypt certonly \
  --server https://acme-staging.api.letsencrypt.org/directory \
  --domain $DOMAIN \
  --authenticator webroot \
  --webroot-path /etc/letsencrypt/webrootauth/ \
  --email $EMAIL \
  --renew-by-default \
  --agree-tos
