#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 17:37:13 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
define mesos::service(
  $enable = true
) {
  service { "mesos-${name}":
    enable     => $enable,
    ensure     => 'running',
    hasstatus  => true,
    hasrestart => true,
    require    => [
                    Class['mesos::install'],
                    Class['mesos::config'],
                  ]
  }
}
