#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

EXPECTEDARGS=1
if [ $# -lt $EXPECTEDARGS ]; then
  echo "Usage: $0 <TARBALL>"
  exit 1
fi

TARBALL=$1
DATA_VOL_CONT=letsencrypt-data

# create new data vol container
docker create -v /etc/letsencrypt --name $DATA_VOL_CONT busybox true

# restore letsencrypt /etc/letsencrypt into data vol container's /etc/letsencrypt
docker run --rm --volumes-from $DATA_VOL_CONT \
    -v $(pwd)/$TARBALL:/backup.tar.gz \
    debian bash -c \
    "tar xzvf /backup.tar.gz -C /etc/letsencrypt; mv /etc/letsencrypt/etc/letsencrypt/* /etc/letsencrypt; rm -rf /etc/letsencrypt/etc"

# check that the new container matches backup data
docker run --rm --volumes-from $DATA_VOL_CONT busybox ls -alh /etc/letsencrypt
