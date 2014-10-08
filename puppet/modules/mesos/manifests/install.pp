#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 11:57:54 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::install {
  include mesos::repo
  ensure_packages(['python'])

  package { 'mesos':
    ensure  => $mesos::common::version,
    name    => $mesos::common::package_name,
    require => Class['mesos::repo']
  }
  contain mesos::repo
}
