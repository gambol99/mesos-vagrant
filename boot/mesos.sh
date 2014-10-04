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

MASTER_HOST=10.99.250.10
SLAVE_HOST=10.99.250.11

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
sudo apt-get -y install mesos

[ $HOSTNAME == $MASTER_HOST ] && sudo apt-get -y marathon

annonce "Setting up the upstart scripts"

[ -f "/etc/init.d/mesos-master" ] || ln -s /lib/init/upstart-job /etc/init.d/mesos-master
[ -f "/etc/init.d/mesos-slave"  ] || ln -s /lib/init/upstart-job /etc/init.d/mesos-slave


if $HOSTNAME == $MASTER_HOST; then
  annonce "MASTER NODE"

  annonce "Configuring zookeeper"
  [[ "$HOSTNAME" =~ ^[a-z\-]*([0-9]*)$ ]] && echo ${BASH_REMATCH[1]} > /etc/zookeeper/conf/myid

  sudo cat <<EOF >/etc/zookeeper/conf/zoo.cfg
server.101=$MASTER_HOST:2888:3888
EOF
  annonce "Setting up the quorum"
  sudo echo "1" > /etc/mesos-master/quorum

  annonce "Configuring Mesos Zookeeper"
  sudo cat <<EOF > /etc/mesos/zk 
zk://$MASTER_HOST:2181/mesos
EOF

  annonce "Restarting zookeeper"
  sudo /sbin/service zookeeper restart

  annonce "Disabling the slave service"
  sudo service mesos-slave stop
  sudo sh -c "echo manual > /etc/init/mesos-slave.override"

  annonce "Restarting the master and marathon service"
  sudo service mesos-master restart
  sudo service marathon restart

else
  annonce "SLAVE NODE"

  annonce "Setting up the slave node"
  sudo service zookeeper stop
  sudo sh -c "echo manual > /etc/init/zookeeper.override"

  annonce "Configuring Mesos Zookeeper"
  sudo cat <<EOF > /etc/mesos/zk 
zk://$MASTER_HOST:2181/mesos
EOF

  sudo service mesos-slave start
fi

