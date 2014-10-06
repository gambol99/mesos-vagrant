#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-06 12:16:03 +0100 (Mon, 06 Oct 2014)
#
#  vim:ts=2:sw=2:et
#

annonce() {
  [ -z "$@" ] && echo "* $@"
}

CLUSTER_NAME="mesos"
NETWORK=10.0.1
MASTER_HOST_ID=100
SLAVE_NODE_ID=101
MASTER_HOST="${NETWORK}.${MASTER_HOST_ID}"
HOSTS_FILE=/etc/hosts

# Host files
echo -e "127.0.0.1\tlocalhost" > $HOSTS_FILE
echo -e "${MASTER_HOST}\tmesos-master101" >> $HOSTS_FILE

annonce "Setting up the hosts file"
for ((id=$SLAVE_NODE_ID, i=0; i<10; i++, id++)); do
  echo -e "${NETWORK}.${id}\tmesos-slave${id}" >> $HOSTS_FILE
done

# Respository
annonce "Setting up the repositories"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
sudo echo "deb http://repos.mesosphere.io/ubuntu trusty main" >> /etc/apt/sources.list.d/mesosphere.list
sudo apt-get update

annonce "Installing packages"
sudo apt-get -y install docker.io mesos marathon

annonce "Setting up the upstart scripts"
[ -f "/etc/init.d/mesos-master" ] || ln -s /lib/init/upstart-job /etc/init.d/mesos-master
[ -f "/etc/init.d/mesos-slave"  ] || ln -s /lib/init/upstart-job /etc/init.d/mesos-slave

annonce "Configuring zookeeper"
[[ "$HOSTNAME" =~ ^[a-z\-]*([0-9]*)$ ]] && echo ${BASH_REMATCH[1]} > /etc/zookeeper/conf/myid

sudo sed -i "s/#server.*/server.101=$MASTER_HOST:2888:3888/" /etc/zookeeper/conf/zoo.cfg

sudo echo "1" > /etc/mesos-master/quorum
sudo echo "$CLUSTER_NAME" > /etc/mesos-master/cluster

annonce "Configuring Mesos Zookeeper"
sudo echo "zk://$MASTER_HOST:2181/mesos" > /etc/mesos/zk

annonce "Restarting zookeeper"
sudo service zookeeper start
annonce "Disabling the slave service"
sudo service mesos-slave stop
sudo sh -c "echo manual > /etc/init/mesos-slave.override"

annonce "Restarting the master and marathon service"
sudo service mesos-master restart
sudo service marathon restart
