class etcd::install {
  package {
    'etcd':
      ensure => $etcd::version,
      name   => $etcd::package_name;
  }
}
