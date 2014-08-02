#MariaDB (https://mariadb.org/)

FROM phusion/baseimage:0.9.12
MAINTAINER William Dahlstrom <w.dahlstrom@me.com>

# Generate UTF-8 lang files just in case
RUN locale-gen en_US.UTF-8

# Disable baseimage's automatic generation of SSH keys
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Update repositories, install prerequisites and add a new one
RUN apt-get -qq update
RUN apt-get -qqy install --no-install-recommends software-properties-common python-software-properties inotify-tools
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://ftp.ddg.lth.se/mariadb/repo/10.0/ubuntu trusty main'
RUN apt-get -qq update

# Install MariaDB & inotify-tools
RUN apt-get -y install mariadb-server || :

# Clean up apt when we're done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add our configuration files, scripts and set correct permissions
ADD conf/sysctl.conf /etc/sysctl.conf
ADD conf/my.cnf /etc/mysql/my.cnf
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN chmod 644 /etc/mysql/my.cnf
RUN touch /firstrun

# Expose port 3306
EXPOSE 3306

# Exposeour data and log direcotires
VOLUME ["/data", "/var/log"]

# Use baseimage-docker's init system
CMD ["/sbin/my_init", "--", "/scripts/start.sh"]
