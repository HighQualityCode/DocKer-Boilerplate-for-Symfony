all: deploy

#############################
# Create new project
#############################

create-cms-project:
	bash bin/create-project.sh cms

create-neos-project:
	bash bin/create-project.sh neos

#############################
# MySQL
#############################

mysql-backup:
	docker-compose run --rm --no-deps main bash /docker/bin/backup.sh mysql

mysql-restore:
	docker-compose run --rm --no-deps main bash /docker/bin/restore.sh mysql

#############################
# Solr
#############################

solr-backup:
	docker-compose stop solr
	docker-compose run --rm --no-deps main bash /docker/bin/backup.sh solr
	docker-compose start solr

solr-restore:
	docker-compose stop solr
	docker-compose run --rm --no-deps main bash /docker/bin/restore.sh solr
	docker-compose start solr

#############################
# General
#############################

backup:  mysql-backup  solr-backup
restore: mysql-restore solr-restore

deploy:
	bash bin/deploy.sh

clean:
	test -d code/typo3temp && { rm -rf code/typo3temp/*; }

bash:
	docker-compose run --rm main bash

#############################
# TYPO3
#############################

scheduler:
	docker-compose run --rm main typo3/cli_dispatch.phpsh scheduler