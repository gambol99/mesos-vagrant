class etcd(
  $version      = 'installed',
  $package_name = 'etcd',
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
