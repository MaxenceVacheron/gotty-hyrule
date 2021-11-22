#!/bin/bash

docker-compose -f /home/pi/gotty-hyrule/docker-compose.yml up -d
gotty --port 51234 -w docker exec -it hyrule ./hyrule_castle.sh

