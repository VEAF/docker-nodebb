#!/bin/bash

ENV_FILE=.env

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "!!! file .env is missing, use make autoconf before !!!"
  exit 1
fi

source .env

if [[ -z "${BACKUP_DATA}" ]]; then
  echo "!!! BACKUP_DATA variable is missing (add it to .env) !!!"
  exit 1
fi

if [[ ! -d "${BACKUP_DATA}" ]]; then
  echo "!!! BACKUP_DATA path not exists, use 'mkdir ${BACKUP_DATA}' to create it before !!!"
  exit 1
fi

FILE=${BACKUP_DATA}/data-$(date +%Y%m%d).tgz

if [[ -f "${FILE}" ]]; then
  echo "!!! FILE already exists, remove it before !!!"
  exit 1
fi

tar -czvf ${FILE} data/
echo backup file ${FILE} created
