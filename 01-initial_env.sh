#!/bin/bash

# Dapatkan nama direktori saat ini
DIR_NAME=${PWD##*/}
CONFIG_DIR=conf.d
DATA_DIR=data
PASSWORD=xxx # Gantilah 'xxx' dengan password Anda
PORT=nnnn # Gantilah 'nnnn' sesuai dengan nomor port yang digunakan


# Buat atau perbarui file .env dengan nama direktori
echo "CONTAINER_NAME=$DIR_NAME" > .env
echo "MYSQL_ROOT_PASSWORD=$PASSWORD" >> .env
echo "CONFIG_DIR=$CONFIG_DIR" >> .env
echo "DATA_DIR=$DATA_DIR" >> .env
echo "PORT=$PORT" >> .env

# Periksa apakah jaringan "my_network" sudah ada
NETWORK_EXISTS=$(docker network ls | grep my_network)

# Periksa apakah direktori conf.d dan data sudah ada
CONFIG_DIR_EXISTS=$(ls | grep conf.d)
DATA_DIR_EXISTS=$(ls | grep data)

# Jika jaringan "my_network" tidak ada, buat jaringan "my_network"
if [ -z "$NETWORK_EXISTS" ]; then
    docker network create --subnet=192.168.253.0/24 --gateway 192.168.253.1 my_network
fi

if [ -z "$CONFIG_DIR_EXISTS" ]; then
    mkdir conf.d
fi

if [ -z "$DATA_DIR_EXISTS" ]; then
    mkdir data
fi

# Gantikan placeholder dengan nama direktori dalam file template
sed "s/SERVICE_NAME_PLACEHOLDER/$DIR_NAME/g" docker-compose-template.yml > docker-compose.yml

# Jalankan docker-compose
docker compose up -d