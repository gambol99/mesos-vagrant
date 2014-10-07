#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 12:29:28 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class zookeeper::install {
  include repos

  package {
    'zookeeper':
      ensure  => $zookeeper::version,
      require => Class['repos'];
  }

  ensure_packages($zookeeper::packages)
}
