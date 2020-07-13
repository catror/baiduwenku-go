#!/bin/bash
set -e
docker-compose up -d --build
docker start wenku
echo 监听成功！
