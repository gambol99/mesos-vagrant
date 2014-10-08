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

  $slave_options = hiera_hash('mesos::slave::options',{})

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
  create_resources( 'mesos::config::slave', $slave_options )

  mesos::service { 'slave': }
}
