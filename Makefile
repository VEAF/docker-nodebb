.PHONY: help

## Display this help text
help:
	$(info ---------------------------------------------------------------------)
	$(info -                        Available targets                          -)
	$(info ---------------------------------------------------------------------)
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                                                \
	nb = sub( /^## /, "", helpMsg );                                            \
	if(nb == 0) {                                                               \
		helpMsg = $$0;                                                      \
		nb = sub( /^[^:]*:.* ## /, "", helpMsg );                           \
	}                                                                           \
	if (nb)                                                                     \
		printf "\033[1;31m%-" width "s\033[0m %s\n", $$1, helpMsg;          \
	}                                                                           \
	{ helpMsg = $$0 }'                                                          \
	$(MAKEFILE_LIST) | column -ts:

-include .env

# auto configure .env
.env:
	cp .env.dist .env
	include .env

# auto configure config.json
config.json:
	cp config.json.dist config.json

# auto configure plugins.lst
plugins.lst:
	cp plugins.lst.dist plugins.lst

## autoconfig
autoconfig: .env config.json

## pull last dependencies
pull: autoconfig
	docker-compose pull

## build custom images
build: autoconfig
	docker image build --pull --build-arg NODEBB_TAG=${NODEBB_TAG} -t nodebdd:${NODEBB_TAG}-veaf .

## start the service
start: autoconfig
	docker-compose up -d

## up (start alias)
up: start

## force-up
force-up: autoconfig
	docker-compose up -d --force-recreate nodebb

## stop the service
stop:
	docker-compose stop

# stop only nodebb
stop-nodebb:
	docker-compose stop nodebb

## upgrade
upgrade: build force-up up

## remove the service
down:
	docker-compose down --remove-orphans --volumes

## restart the proxy service
restart: stop start

## enter in nodebb container
nodebb:
	docker-compose exec nodebb bash

## show logs
logs:
	docker-compose logs -f --tail=1000

## show status
ps:
	docker-compose ps

## backup data (compress)
backup:
	./backup.sh
