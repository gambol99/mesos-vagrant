#
#   Author: Rohith
#   Date: 2014-10-07 23:30:26 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class resolv(
  $search_domains = $::domain,
  $nameservers    = [ '8.8.8.8', '8.8.4.4' ],
  $options        = [
                      'rotate',
                      'timeout:2',
                    ],
  $resolver       = '/etc/resolv.conf',
) {
  class { 'install': }
  ->
  class { 'config':  }
}
