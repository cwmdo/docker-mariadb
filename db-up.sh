#!/bin/bash

# Configure settings here
NAME="mysqsl-prod-0"
PORT="3306"
HOSTSTORAGE="/home/deploy/db/mysql-prod-0"
LOGSTORAGE="/home/deploy/logs/mysql-prod-0"

# Color variables to make messages pretty
Yel="\e[1;33m"
Red="\e[1;31m"
RCol="\e[0m"

# Validate settings
# Does the host storage directory exist? If not, let's create one
if [ ! -d "$HOSTSTORAGE" ]; then
  echo -e "${Yel}[Notice]${RCol} Host storage directory doesn't exist, creating it for you..."
  mkdir -p $HOSTSTORAGE
fi

# Does the host log directory exist? If not, let's create one
if [ ! -d "$LOGSTORAGE" ]; then
  echo -e "${Yel}[Notice]${RCol} Host log directory doesn't exist, creating it for you..."
  mkdir -p $LOGSTORAGE
fi

# Is the port already bound? If so, tell the user.
PORTCHECK=`docker ps | grep "$PORT" | wc -l`

if [ "$PORTCHECK" -ne 0 ]; then
	echo -e "${Red}[Error]${RCol} Port $PORT is already in use by another container, pick a different one."
	exit 2

fi

# Did the user pass a username and password? If not, tell them
if [ $# -eq 0 ]; then
    echo -e "${Red}[Error]${RCol} No username or password passed."
    exit 2
fi

# Inject our variables into the docker command and run it
docker build -t mariadb github.com/heyimwill/docker-mariadb && docker run -d --name="$NAME" -p $PORT:3306 -v $HOSTSTORAGE:/data -v $LOGSTORAGE:/logs -e USER="$1" -e PASS="$2" mariadb
