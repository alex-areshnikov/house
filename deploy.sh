#!/bin/bash

docker-compose down
docker build -t sanchorubyroid/house:latest .
docker-compose up -d
