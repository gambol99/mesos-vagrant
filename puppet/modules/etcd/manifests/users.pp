#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-14 15:05:54 +0100 (Tue, 14 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class etcd::users {
  group { $etcd::group:
    ensure    => present,
    allowdupe => false,
  }
  ->
  user { $etcd::user:
    ensure    => present,
    allowdupe => false,
    home      => '/etc/etcd',
    shell     => '/bin/bash',
    groups    => $etcd::group,
  }
}
