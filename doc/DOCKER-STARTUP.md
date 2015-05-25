[<-- Back to main section](../README.md)

# First startup

## Create project

Checkout this project and create and run the Docker containers using [docker-compose](https://github.com/docker/compose):

```bash
git clone https://github.com/mblaschke/TYPO3-docker-boilerplate.git projectname
cd projectname
docker-compose up -d
```

Now create your project inside the docker boilerplate:

- [Create new TYPO3 project](doc/PROJECT-TYPO3.md)
- [Create new Symfony project](doc/PROJECT-SYMFONY.md)
- [Create new NEOS project](doc/PROJECT-NEOS.md)
- [Running any other php based project](doc/PROJECT-OTHER.md)
- [Running existing project](doc/PROJECT-EXISTING.md)

For an existing project just put your files into `code/` folder or use git to clone your project into `code/`.

## Advanced usage (git)

Use this boilerplate as template and customize it for each project. Put this Docker
configuration for each project into seperate git repositories.

Now set your existing project repository to be a git submodule in `code/`.
Every developer now needs only to clone the Docker repository with `--recursive` option
to get both, the Docker configuration and the TYPO3 installation.

For better useability track a whole branch (eg. develop or master) as submodule and not just a single commit.
