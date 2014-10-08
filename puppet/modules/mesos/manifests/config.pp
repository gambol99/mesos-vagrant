#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 11:56:01 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::config {
  file {
    '/etc/mesos':
      ensure => directory,
      owner  => $mesos::common::owner,
      group  => $mesos::common::group;

    '/var/log/mesos':
      ensure => directory,
      owner  => $mesos::common::owner,
      group  => $mesos::common::group;
  }

  etc::sysconfig { 'default':
    content  => template("${module_name}/default.erb"),
  }

  mesos::config::option { 'zk':
    content => template("${module_name}/zk.erb")
  }
}
