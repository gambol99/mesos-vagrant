#!/bin/bash
#
#   Author: Rohith
#   Date: 2014-09-30 23:22:47 +0100 (Tue, 30 Sep 2014)
#
#  vim:ts=2:sw=2:et
#
#

annonce() {
  [ -z "$@" ] && echo "* $@"
}

# Respository
annonce "Setting up the repositories"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
sudo echo "deb http://repos.mesosphere.io/ubuntu trusty main" >> /etc/apt/sources.list.d/mesosphere.list
sudo apt-get update

# Docker
annonce "Installing docker"
sudo apt-get -y install docker.io

# Install Mesos
annonce "Installing Mesos"
sudo apt-get -y install mesos marathon

annonce "Configuring zookeeper"
[[ "$HOSTNAME" =~ ^[a-z\-]*([0-9]*)$ ]] && echo ${BASH_REMATCH[1]} > /etc/zookeeper/conf/myid

