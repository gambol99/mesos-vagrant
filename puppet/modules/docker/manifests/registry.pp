#
#   Author: Rohith
#   Date: 2014-10-16 21:08:27 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::registry(
  $version        = '0.8.1',
  $storage_path   = '/var/docckers',
  $package_deps = []
) {
  class { 'install': }
  ->
  class { 'config':  }
}
