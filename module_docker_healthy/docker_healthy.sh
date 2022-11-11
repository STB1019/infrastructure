#!/bin/bash

# Get URL from command-line arguments
CONTAINER_NAME="$1"
if [ -z "${CONTAINER_NAME}" ]; then echo >&2 'Error: CONTAINER_NAME not specified'; exit 1; fi

# Other configuration
WAIT=5
TRIES=50

echo "Running wait script for container ${CONTAINER_NAME} wait/tries ${WAIT}/${TRIES}" >&2

while true; do

    if [ $TRIES -eq 0 ]; then
        echo >&2 "TRIES LIMIT EXCEEDED"
        exit 1
    fi

    STATE=$(docker inspect --format='{{json .State.Health}}' ${CONTAINER_NAME} || echo '{"Status": "not_started"}')
    echo >&2 "$TRIES - Got state $(echo "$STATE" | jq -r '.Status')"

    case $(echo "$STATE" | jq -r '.Status') in
        "healthy")
            IP="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME})"
            echo >&2 "Container ${CONTAINER_NAME} is healthy at ${IP}"
            echo '{"container":"'"${CONTAINER_NAME}"'", "ip": "'"${IP}"'"}'
            exit 0
        ;;
        "starting")
        ;;
        "not_started")
            echo >&2 "Container ${CONTAINER_NAME} not yet started"
        ;;
        *)
            echo >&2 "Container ${CONTAINER_NAME} is dead"
            exit 128
        ;;
    esac
    TRIES=$(($TRIES-1))
    sleep $WAIT
done