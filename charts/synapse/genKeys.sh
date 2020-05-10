#!/bin/bash

matrix_host=$1

if [ -z $matrix_host ]; then
    echo "You must run ./genKeys.sh <SERVER_NAME>"
    exit 1
fi

docker run -i --rm -v $(pwd)/synapse-data:/data -e SYNAPSE_SERVER_NAME=$matrix_host -e SYNAPSE_REPORT_STATS=no matrixdotorg/synapse:latest migrate_config

printf "\n\nmacaroonSecretKey: "
cat synapse-data/${matrix_host}.macaroon.key
printf "\nregSharedSecret: "
cat synapse-data/${matrix_host}.registration.key
printf "\nsigningKeyB64: "
cat synapse-data/${matrix_host}.signing.key | base64
printf "\n\nDone! Replace those values in the values.yaml file.\n"

