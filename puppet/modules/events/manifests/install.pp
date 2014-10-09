#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-09 12:36:55 +0100 (Thu, 09 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class events::install {
  include rabbitmq

  package { 'ruby-amqp':
    ensure => installed,
  }
}
