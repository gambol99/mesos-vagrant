class etcd::install {

  include etcd::users

  staging::deploy { "${etcd::version}.tar.gz":
    source => "https://github.com/coreos/etcd/releases/download/v0.4.6/${etcd::version}.tar.gz",
    user   => 'root',
    group  => 'root',
    target => '/opt',
  }
  ->
  file {
    '/usr/sbin/etcd':
      ensure => 'link',
      target => "/opt/${etcd::version}/etcd";

    '/usr/bin/etcdctl':
      ensure => 'link',
      target => "/opt/${etcd::version}/etcdctl";
  }
}
