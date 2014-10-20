#
#   Author: Rohith
#   Date: 2014-10-17 00:40:22 +0100 (Fri, 17 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
FROM ubuntu
MAINTAINER <gambol99@gmail.com>
RUN apt-get update
RUN apt-get install -y openssh-server wget vim
RUN mkdir -p /etc/confd/conf.d /etc/confd/templates
ADD config/confd.conf /etc/confd/confd.confs
RUN wget https://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64 -O /usr/bin/confd


EXPOSE 22
