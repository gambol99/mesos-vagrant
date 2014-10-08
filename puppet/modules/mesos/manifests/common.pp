#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 16:15:14 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::common(
  $version      = 'installed',
  $package_name = 'mesos'
) {
  require repos
  require etc::hosts

  $common_options = hiera_hash('mesos::common::options',{})

  class { 'install': }
  ->
  class { 'config':  }

  contain mesos::install
  contain mesos::config
}
