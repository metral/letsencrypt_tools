#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p backups > /dev/null

date=`date +"%Y-%m-%d-%s"`
backup_path=backups/backup_$date.tar.gz
DATA_VOL_CONT=letsencrypt-data

# backup $DATA_VOL_CONT
docker run \
  --rm \
  --volumes-from $DATA_VOL_CONT \
  -v $(pwd):/backup \
  debian \
  tar cvzf /backup/$backup_path etc/letsencrypt

echo ""
echo "$backup_path was created."
