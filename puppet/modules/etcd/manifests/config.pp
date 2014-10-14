class etcd::config {
  include etcd::users

  file {
    '/etc/etcd/etcd.conf':
      owner   => $etcd::user,
      group   => $etcd::group,
      mode    => '0440',
      notify  => Service['etcd'],
      content => template("${module_name}/etcd.conf.erb"),
      require => Class['etcd::users'];

    '/etc/init.d/etcd':
      mode    => '0755',
      source  => "puppet:///modules/${module_name}/init.d/etcd";

    '/etc/sysconfig/etcd':
      mode    => '0444',
      content => template("${module_name}/sysconfig/etcd.erb");

    $etcd::config['data_dir']:
      ensure  => directory,
      owner   => $etcd::user,
      group   => $etcd::group,
      require => Class['etcd::users'];

    '/var/log/etcd':
      ensure  => directory,
      owner   => $etcd::user,
      group   => $etcd::group,
      mode    => '0775',
      require => Class['etcd::users'];
  }
}
