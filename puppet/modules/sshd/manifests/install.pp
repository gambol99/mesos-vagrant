#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-11-05 10:23:37 +0000 (Wed, 05 Nov 2014)
#
#  vim:ts=2:sw=2:et
#
class sshd::install {
  package { 'openssh':
    ensure  => $sshd::version,
    name    => $sshd::package_name,
  }
}
