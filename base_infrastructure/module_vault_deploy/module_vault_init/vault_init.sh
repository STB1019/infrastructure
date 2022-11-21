#!/bin/sh

# Get URL from command-line arguments
CONTAINER_NAME="$1"
if [ -z "${CONTAINER_NAME}" ]; then echo >&2 'Error: CONTAINER_NAME not specified'; exit 1; fi
CONF_DIR="$2"
if [ -z "${CONF_DIR}" ]; then echo >&2 'Error: CONF_DIR not specified'; exit 1; fi

RESULT=$(curl "http://${CONTAINER_NAME}:8200/v1/sys/init" | jq '.initialized')
echo >&2 "${RESULT}"

if [ "$RESULT" == "true" ]; then

    #TODO UNSEAL

    TOKEN=$(cat "${CONF_DIR}/creds" | jq '.root_token')
    echo "{\"token\": \"${TOKEN}\"}"    
    exit 0
fi

RESULT=$(curl "http://${CONTAINER_NAME}:8200/v1/sys/init" -X POST -H "Content-Type: application/json" -d '{"secret_shares": '"$3"', "secret_threshold": '"$4"'}')
echo >&2 "$RESULT" 

echo "${RESULT}" > "${CONF_DIR}/creds"
TOKEN=$(cat "${CONF_DIR}/creds" | jq '.root_token')
echo >&2 "$TOKEN" 

#TODO UNSEAL
echo "{\"token\": \"${TOKEN}\"}"
exit 1
echo "{\"token\": \"${TOKEN}\"}"