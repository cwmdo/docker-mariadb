Just another MariaDB container
============

Pretty much what the title says, but with some minor additions. This container was built to be run in tandem with this PHP stack: http://github.com/heyimwill/docker-php5-nginx but it isn't picky and should play nice with whatever you pair it up with. It comes pre-configured for production and is tuned for performance, but I suggest you modify it for your own system specs, e.g with this great tool: https://tools.percona.com/wizard. Username/password is configured through environment variables and complies with the Twelve-Factor methodology (http://12factor.net) if that's up your alley.

## Features
* Installs MariaDB 10.0 (a drop in replacement for MySQL)
* Tuned my.cnf (if ram <8Gb generate your own here: https://tools.percona.com/wizard)
* Tuned sysctl.conf
* Easily access logs
* Compatible with the Twelve Factor Methodology (http://12factor.net)

## Quick start script
If you just want to get things up and running, simply use the db-up.sh script in this repo. Make sure you adjust the settings at the beginning of the file to suit your system, then simply run it like so, username/password will set the login info for your mysql user:

```./db-up.sh username password```

That's it, you're all set!

## Setup
Not a fan of taking shortcuts, eh? Lets do it the good ol' way.

Grab the latest version of this image from the Docker index:
```
docker pull heyimwill/docker-mariadb
```
You can also build the image yourself right from this repo:
```
docker build -t mariadb-prod-0 github.com/heyimwill/docker-mariadb
```

## Running
For this container to run at all, these environment variables need to be defined: USER, PASS. It expects you to mount your data directory to ```/data```. If you would like easy access to the logs, you can mount ```/logs```.

The final result looks something like this:
```docker run -d --name="mysql-prod-0" -p 3307:3306 -v /home/deploy/db/mysql-prod-0:/data -v /logs -e USER="chuck" -e PASS="intersect" heyimwill/docker-mysql```

## Linking
If you want to link this to another container, simply add ```--link mysql-prod-0:db``` to the docker command of the container you wish to link with. If you're setting up a PHP environment, you should definitely check this out: http://github.com/heyimwill/docker-php5-nginx

## Roadmap


