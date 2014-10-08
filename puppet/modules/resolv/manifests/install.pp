#
#   Author: Rohith
#   Date: 2014-10-07 23:30:35 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class resolv::install {
  ensure_packages(['bind-utils'])
}
