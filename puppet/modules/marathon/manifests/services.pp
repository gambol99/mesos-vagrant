#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 18:12:20 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class marathon::services {
  service { 'marathon':
    status => '/usr/sbin/service marathon | grep -q running',
  }

  if $::operatingsystem == 'Ubuntu' {
    # marathon returns 0 on exit even when not running, and for some reason the status field
    # in the puppet service isn't being implemented!!! ARRRRGGG
    exec { 'Ubuntu Marathon Service hack':
      command => '/usr/sbin/service marathon start',
      unless  => '/usr/sbin/service marathon status | grep -q running'
    }
  }
}
