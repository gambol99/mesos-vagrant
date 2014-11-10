#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-11-05 10:23:31 +0000 (Wed, 05 Nov 2014)
#
#  vim:ts=2:sw=2:et
#
class ssh(
  $version      = 'installed',
  $package_name = 'openssh-server',
) {
  $authorized_keys = hiera_hash('sshd::authorized_keys',{})

  class { 'install':  }
  ->
  class { 'config':   }
  ->
  class { 'services': }
}
