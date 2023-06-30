#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Please provide the image name as an argument"
    exit -1
fi

export TAG=$1
docker-compose -f docker-compose.yaml up -d

if [ $? -eq 0 ]; then
    echo "Server started successfully"
else
    echo "Server failed to start"
fi
