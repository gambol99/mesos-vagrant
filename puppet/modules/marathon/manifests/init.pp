#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 18:12:15 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class marathon(
  $version      = 'installed',
  $package_name = 'marathon',

) { 
  require mesos::master

  class { 'install':  }
  ->
  class { 'config':   }
  -> 
  class { 'services': }
}
