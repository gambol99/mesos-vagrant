#!/bin/bash
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-21 13:53:04 +0100 (Tue, 21 Oct 2014)
#
#  vim:ts=2:sw=2:et
#

CONFD_CONFIG_FILE=/etc/confd/confd.conf
CONFD="/usr/bin/confd"

annonce() {
  echo -e "[annonce] $@"
}

wait_on_confd() {


}

# step: do we need to update the nodes in the confd
update_confd_backend() {
  if [ -n $SERVICE_DISCOVERY ]; then
    annonce "updating the confd config file: $CONFD_CONFIG_FILE"
    sed -i "s/nodes.*/nodes = [ $SERVICE_DISCOVERY ]/" $CONFD_CONFIG_FILE
    annonce "updating the confd config nodes: $SERVICE_DISCOVERY"
  else
    annonce "no need to update the confd nodes configuration"
  fi
}

update_confd_onetime() {




}

startup() {
  # update the confd backend nodes
  update_confd_backend
  # step: wait for confd to be online
  wait_on_confd
  # step: pull down any onetime confs
  update_confd_onetime
  # step:


}


startup
# step: enter into supervisord
annonce "entering into supervisord daemon service"
/usr/bin/supervisord -n
