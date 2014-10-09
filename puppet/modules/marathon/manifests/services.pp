#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 18:12:20 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class marathon::services {
  service { 'marathon':
    hasstatus => false,
  }
}
