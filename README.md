# Dockerized TYPO3 Project (CMS, FLOW, NEOS)

A TYPO3 boilerplate project utilizing Docker based with support
for **TYPO3_CONTEXT** and **FLOW_CONTEXT**

Supports:

- Nginx or Apache HTTPd
- PHP-FPM
- MySQL, MariaDB or PerconaDB
- Solr
- Elasticsearch (without configuration)

This Docker boilerplate based on the best practises and don't use too much magic.
Configuration of each docker container is availabe in the docker/ directory - feel free to customize.

This boilerplate can also be used for any other web project eg. TYPO3 NEOS, Symfony, Magento and more.
Just customize the makefile for your needs

Warning: Don't use this Docker containers for production - they are only for development!


## Requirements

- GNU/Linux with Docker (recommendation: Vagrant VM with Docker or native Linux with Docker)
- make
- [composer](https://getcomposer.org/)
- [docker-compose](https://github.com/docker/compose)

If you want to run a Docker VM make sure you're using VMware or Parallels Desktop because of
the much faster virtualisation (networking, disk access, shared folders) compared to VirtualBox.


## Running TYPO3

You can run the Docker environment using [docker-compose](https://github.com/docker/compose):

    $ docker-compose up -d

### Create TYPO3 CMS project

For the first TYPO3 CMS setup (make sure [composer](https://getcomposer.org/) is installed):

    $ make create-cms-project

or

    $ rm -f htdocs/.gitkeep
    $ composer create-project typo3/cms-base-distribution htdocs/
    $ touch htdocs/FIRST_INSTALL htdocs/.gitkeep


Feel free to modify your TYPO3 installation in your htdocs (a shared folder of Docker),
most of the time there is no need to enter any Docker container.

#### TYPO3 CMS cli runner

You can run one-shot command inside the `TYPO3` service container:

    $ docker-compose run --rm typo3 typo3/cli_dispatch.phpsh scheduler

    $ docker-compose run --rm typo3 bash

Webserver is available at Port 8000

### Create TYPO3 NEOS project

For the first TYPO3 NEOS setup (make sure [composer](https://getcomposer.org/) is installed):

    $ make create-neos-project

or

    $ rm -f htdocs/.gitkeep
    $ composer create-project typo3/neos-base-distribution htdocs/
    $ touch htdocs/.gitkeep


Feel free to modify your TYPO3 NEOS installation in your htdocs (a shared folder of Docker),
most of the time there is no need to enter any Docker container.


#### TYPO3 NEOS cli runner

You can run one-shot command inside the `TYPO3` service container:

    $ docker-compose run --rm typo3 flow core:setfilepermissions

    $ docker-compose run --rm typo3 bash

Webserver is available at Port 8000


### Existing project

Just put your TYPO3 project inside the htdocs folder or use git to checkout your project into htdocs.


## Informations


### Makefile

Command                   | Description
------------------------- | -------------------------------
make clean                | Clear TYPO3 configuration cache
make mysql-backup         | Backup MySQL database
make mysql-restore        | Restore MySQL database
make deploy               | Run deployment (composer, gulp, bower)
make create-cms-project   | Create new TYPO3 CMS project (based on typo3/cms-base-distribution)
make create-neos-project  | Create new TYPO3 NEOS project (based on typo3/neos-base-distribution)
make scheduler            | Run TYPO3 scheduler


### MySQL

You can choose between [MySQL](https://www.mysql.com/) (default), [MariaDB](https://www.mariadb.org/)
and [PerconaDB](http://www.percona.com/software) in docker/mysql/Dockerfile

Setting       | Value
------------- | -------------
User          | dev (if not changed in env)
Password      | dev (if not changed in env)
Database      | typo3 (if not changed in env)
Host          | mysql:3306
External Port | 13306

Access fo MySQL user "root" and "dev" will be allowed from external hosts (eg. for debugging, dumps and other stuff).


### Solr

Setting       | Value
------------- | -------------
Host          | solr:8983
External Port | 18983
Cores         | docker/solr/conf/solr.xml (data dirs are created automatically)

### Elasticsearch (disabled by default)

Setting       | Value
------------- | -------------
Host          | elasticsearch:9200 and :9300
External Port | 19200 and 19300

### Environment settings

Environment           | Description
--------------------- | -------------
TYPO3_CONTEXT         | Context for TYPO3, can be used for TypoScript conditions and AdditionalConfiguration
FLOW_CONTEXT          | Context for TYPO3 FLOW an NEOS
<br>                  |
MYSQL_ROOT_PASSWORD   | Password for MySQL user "root"
MYSQL_USER            | Initial created MySQL user
MYSQL_PASSWORD        | Password for initial MySQL user
MYSQL_DATABASE        | Initial created MySQL database

## Advanced usage (git)

Use this boilerplate as template and customize it for each project. Put this Docker
configuration for each project into seperate git repositories.

Now set your existing TYPO3 repository to be a git submodule in htdocs/.
Every developer now needs only to clone the Docker repository with **--recursive**
to get both, the Docker configuration and the TYPO3 installation.

For better useability track a whole branch (eg. develop or master) as submodule and not just a single commit.

## Credits

This Docker layout is based on https://github.com/denderello/symfony-docker-example/

Thanks to [cron IT GmbH](http://www.cron.eu/) for the inspiration for this Docker boilerplate.