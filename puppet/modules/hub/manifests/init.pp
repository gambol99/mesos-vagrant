#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-16 17:13:21 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class hub() {
  $jenkins_plugins = hiera_hash('hub::jenkins_plugins',{})
  $docker_builds   = hiera_hash('hub::dockers',{})

  class { 'install': }
  ->
  class { 'config':  }
}
