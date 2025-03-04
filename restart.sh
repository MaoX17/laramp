#!/bin/bash
#cd /opt/docker-compose/jellyfin/
docker compose down
sleep 2
docker compose up -d 
