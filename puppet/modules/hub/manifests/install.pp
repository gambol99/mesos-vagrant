#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-16 17:13:25 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class hub::install {
  include jenkins
  include docker
  include docker::registry

  ensure_packages(['git'])
}
