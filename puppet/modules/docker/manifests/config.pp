#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-08 15:24:42 +0100 (Wed, 08 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::config {
  etc::sysconfig { 'docker.io':
    content  => template("${module_name}/sysconfig/docker.erb"),
    notified => Service['docker'],
  }
}
