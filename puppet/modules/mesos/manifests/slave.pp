#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 12:04:59 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::slave(
  $config_dir  = '/etc/mesos-slave',
  $config_file = '/etc/default/mesos-slave',
  $working_dir = '/tmp/mesos',
) inherits mesos::common {

  include docker
  include zookeeper::disabled

  $options = hiera_hash('mesos::slave_options',{})
  $removal = hiera_hash('mesos::slave_options_removal',{})

  file {
    $config_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      recurse => true,
      purge   => true,
      force   => true;

    "${config_dir}/resources":
      ensure  => directory,
      owner   => $owner,
      group   => $group;

    "${config_dir}/attributes":
      ensure  => directory,
      owner   => $owner,
      group   => $group;

    $working_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group;

  }

  # step: add and remove the configuration options
  create_resources( 'mesos::config::option', mesos_property( $options ), {
      type     => 'slave',
      notified => Service['mesos-slave']
    }
  )

  create_resources( 'mesos::config::option', mesos_property( $removal ), {
      ensure   => absent,
      type     => 'slave',
      notified => Service['mesos-slave'],
    }
  )
  mesos::service { 'master':
    enable  => false,
    ensure  => stopped,
  }
  ->
  mesos::service { 'slave': }
}
