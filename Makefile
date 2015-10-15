ARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEFLAGS += --silent

list:
	sh -c "echo; $(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile'| sort"

#############################
# Create new project
#############################

create:
	bash bin/create-project.sh $(ARGS)

#############################
# Docker machine states
#############################

up:
	docker-compose up -d

start:
	docker-compose start

stop:
	docker-compose stop

state:
	docker-compose ps

rebuild:
	docker-compose stop
	docker-compose rm --force main web
	docker-compose build --no-cache

#############################
# Docker cloud
#############################

cloud-build:
	mkdir -p docker/sourcecode/code
	rsync -a code/ docker/sourcecode/code/
	docker-compose --file docker-compose-cloud.yml build
	docker-compose --file docker-compose-cloud.yml build --no-cache sourcecode
	docker-compose --file docker-compose-cloud.yml stop
	docker-compose --file docker-compose-cloud.yml rm --force sourcecode
	docker-compose --file docker-compose-cloud.yml up -d --force-recreate

#############################
# MySQL
#############################

mysql-backup:
	docker-compose run --rm --no-deps main root bash /docker/bin/backup.sh mysql

mysql-restore:
	docker-compose run --rm --no-deps main root bash /docker/bin/restore.sh mysql

#############################
# Solr
#############################

solr-backup:
	docker-compose stop solr
	docker-compose run --rm --no-deps main root bash /docker/bin/backup.sh solr
	docker-compose start solr

solr-restore:
	docker-compose stop solr
	docker-compose run --rm --no-deps main root bash /docker/bin/restore.sh solr
	docker-compose start solr

#############################
# General
#############################

backup:  mysql-backup  solr-backup
restore: mysql-restore solr-restore

build:
	bash bin/build.sh

bash:
	docker-compose run --rm main bash

root:
	docker-compose run --rm main root

#############################
# Argument fix workaround
#############################
%:
	@:
