#!/bin/bash
#cd /opt/docker-compose/jellyfin/
docker compose down
rm src.backup_pre_build.tar.gz
tar -czvf src.backup_pre_build.tar.gz src
sleep 2
#docker-compose up -d  homeassistant
docker compose up --build
sleep 2
docker compose down
sleep 2
docker compose up -d 
