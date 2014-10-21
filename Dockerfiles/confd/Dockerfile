#
#   Author: Rohith
#   Date: 2014-10-20 22:03:46 +0100 (Mon, 20 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
FROM ubuntu
MAINTAINER <gambol99@gmail.com>
RUN sudo apt-get update
RUN sudo apt-get install -y wget
RUN sudo wget http://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64 -O /usr/bin/confd && chmod +x /usr/bin/confd
RUN sudo mkdir -p /etc/confd/conf.d /etc/confd/templates
RUN sudo apt-get install -y vim
ENV ENVIRONMENT dev
ENV APP confd
ENV NAME confd
