#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 12:05:01 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::master(
  $config_file  = '/etc/default/mesos-master',
  $config_dir   = '/etc/mesos-master',
  $working_dir  = '/var/lib/mesos',
) inherits mesos::common {

  include zookeeper

  $options = hiera_hash('mesos::master::options',{})
  $removal = hiera_hash('mesos::master::options_removal',{})

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
    value => $working_dir,
  }

  create_resources( 'mesos::config::option', mesos_property( $options ), {
      type     => 'master',
      notified => Service['mesos-master']
    }
  )

  create_resources( 'mesos::config::option', mesos_property( $removal ), {
      ensure   => absent,
      type     => 'master',
      notified => Service['mesos-master'],
    }
  )
  mesos::service { 'master': }
  ->
  mesos::service { 'slave':
    enable  => false,
    ensure  => stopped,
  }
}
