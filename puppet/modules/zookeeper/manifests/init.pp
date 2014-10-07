#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 12:29:11 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class zookeeper(
  $version      = 'installed',
  $package_name = 'zookeeper',
  $packages     = [],
  $owner        = 'zookeeper',
  $group        = 'zookeeper',
  $config_dir   = '/etc/zookeeper',
  $data_dir     = '/var/lib/zookeeper',
  $datalog_dir  = undef,
  $nodes        = [],
) {
  $options = hiera_hash('zookeeper::options',{})

  class { 'install':   }
  ->
  class { 'config':    }
  ->
  class { 'services':  }
}
