#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 18:36:30 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::install {
  package { 'docker.io':
    alias  => 'docker',
    ensure => $docker::version,
    name   => $docker::package_name,
  }
}
