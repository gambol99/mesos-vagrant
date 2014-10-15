class etcd(
  $version      = 'etcd-v0.4.6-linux-amd64',
  $user         = 'etcd',
  $group        = 'etcd'
) {
  $config = hiera_hash('etcd::config')

  class { 'install':  }
  ->
  class { 'config':   }
  ->
  class { 'services': }
}
