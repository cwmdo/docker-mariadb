#MariaDB (https://mariadb.org/)

FROM ubuntu:14.04
MAINTAINER Ryan Seto <w.dahlstrom@me.com>

# Ensure UTF-8
RUN locale-gen en_US.UTF-8

# Adding up to date repositories
RUN apt-get -qq update
RUN apt-get -qqy install --no-install-recommends software-properties-common python-software-properties
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://ftp.ddg.lth.se/mariadb/repo/10.0/ubuntu trusty main'
RUN apt-get -qq update

# Install MariaDB
RUN apt-get -qq update
RUN apt-get -qqy install --force-yes mariadb-server

# Install other tools.
RUN apt-get -qqy install pwgen inotify-tools

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add configurations
ADD conf/sysctl.conf /etc/sysctl.conf
ADD conf/my.cnf /etc/mysql/my.cnf
EXPOSE 3306
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN chmod 644 /etc/mysql/my.cnf
RUN touch /firstrun

# Expose our data, log, and configuration directories.
VOLUME ["/data", "/var/log/mysql", "/etc/mysql"]

# Use baseimage-docker's init system.
CMD ["/scripts/start.sh"]
