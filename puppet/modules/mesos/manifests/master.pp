#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 12:05:01 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::master(
  $cluster_name = 'mesos',
  $config_file  = '/etc/default/mesos-master',
  $config_dir   = '/etc/mesos-master',
  $working_dir  = '/var/lib/mesos',
) inherits mesos::common {
  include zookeeper

  $master_options = hiera_hash('mesos::master::options',{})

  file {
    $config_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      recurse => true,
      purge   => true,
      force   => true;

    $working_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group;
  }
  ->
  mesos::config::master { 'work_dir':
    value    => $working_dir,
  }
  ->
  mesos::config::master { 'cluster':
    value    => $cluster_name,
  }

  create_resources( 'mesos::config::master', $master_options )

  mesos::service { 'master': }

  contain mesos::common
}
