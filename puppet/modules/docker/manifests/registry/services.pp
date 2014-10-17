#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-17 10:34:10 +0100 (Fri, 17 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::registry::services {
  service { 'docker-registry':
    ensure => running,
    enable => true,
  }
}
