#!/bin/bash

# Get URL from command-line arguments
CONTAINER_NAME="$1"
if [ -z "${CONTAINER_NAME}" ]; then echo >&2 'Error: CONTAINER_NAME not specified'; exit 1; fi

result=$(docker kill --signal="SIGHUP" "$CONTAINER_NAME")
echo '{"result": "'"${result}"'"}'