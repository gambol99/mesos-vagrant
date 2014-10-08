#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-08 14:05:08 +0100 (Wed, 08 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class zookeeper::disabled {
  service { 'zookeeper':
    ensure => stopped,
    enable => false
  }
}
