#!/bin/sh

get_token() {
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" "http://${CONTAINER_NAME}:8200/v1/sys/health")
    if [ ! "$RESULT" == "200" ]; then
        echo >&2 "$RESULT"
        exit 200
    fi
    TOKEN=$(cat "${CONF_DIR}/creds" | jq -r '.root_token')
    echo "{\"token\": \"${TOKEN}\"}"   
}

unseal() {
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" "http://${CONTAINER_NAME}:8200/v1/sys/health")

    if [ ! "$RESULT" == "200" ]; then
        if [ "$RESULT" == "503" ]; then
            for key in $(cat "${CONF_DIR}/creds" | jq -r '.keys[]'); do
                K_RESULT=$(curl -s -o "/dev/null" -w "%{http_code}" "http://${CONTAINER_NAME}:8200/v1/sys/unseal" -X POST -H "Content-Type: application/json" -d '{"key": "'"$key"'"}')
                sleep 0.5
            done
            sleep 2
            return
        fi
        echo >&2 "${RESULT}"
        exit 3
    fi
}

# Get URL from command-line arguments
CONTAINER_NAME="$1"
if [ -z "${CONTAINER_NAME}" ]; then echo >&2 'Error: CONTAINER_NAME not specified'; exit 1; fi
CONF_DIR="$2"
if [ -z "${CONF_DIR}" ]; then echo >&2 'Error: CONF_DIR not specified'; exit 1; fi

RESULT=$(curl -s "http://${CONTAINER_NAME}:8200/v1/sys/init" | jq '.initialized')

if [ "$RESULT" == "true" ]; then
    if [ ! -f "${CONF_DIR}/creds" ]; then
        echo >&2 "No creds file provided, cannot detect token nor keys"
        exit 254
    fi
    unseal
    get_token
    exit 0
fi

RESULT=$(curl -s "http://${CONTAINER_NAME}:8200/v1/sys/init" -X POST -H "Content-Type: application/json" -d '{"secret_shares": '"$3"', "secret_threshold": '"$4"'}')
echo "${RESULT}" | jq -r > "${CONF_DIR}/creds"

unseal
get_token
exit 0