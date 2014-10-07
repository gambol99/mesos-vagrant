#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 12:29:20 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class zookeeper::config {
  file {
    $zookeeper::config_dir:
      ensure  => directory,
      owner   => $zookeeper::owner,
      group   => $zookeeper::group,
      mode    => '0750';

    "${zookeeper::config_dir}/myid":
      owner   => $zookeeper::owner,
      group   => $zookeeper::group,
      mode    => '0444',
      notify  => Service['zookeeper'],
      content => template("${module_name}/conf/myid.erb");

    "${zookeeper::config_dir}/zoo.cfg":
      owner   => $zookeeper::owner,
      group   => $zookeeper::group,
      mode    => '0444',
      notify  => Service['zookeeper'],
      content => template("${module_name}/conf/zoo.cfg.erb");

    "${zookeeper::config_dir}/log4j.properties":
      owner   => $zookeeper::owner,
      group   => $zookeeper::group,
      mode    => '0444',
      notify  => Service['zookeeper'],
      content => template("${module_name}/conf/log4j.properties.erb");

    "${zookeeper::config_dir}/environment":
      owner   => $zookeeper::owner,
      group   => $zookeeper::group,
      mode    => '0444',
      notify  => Service['zookeeper'],
      content => template("${module_name}/conf/environment.erb");

    "${zookeeper::data_dir}":
      ensure  => directory,
      owner   => $zookeeper::owner,
      group   => $zookeeper::group,
      mode    => '0770';

    '/var/log/zookeeper':
      ensure  => directory,
      owner   => $zookeeper::owner,
      group   => $zookeeper::group;
  }
  etc::sysconfig { 'zookeeper':
    notified => Service['zookeeper'],
  }
}
