#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-08 15:37:50 +0100 (Wed, 08 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::services {
  service { 'docker':
    name => $docker::service_name,
  }
}
