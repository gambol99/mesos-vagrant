#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 18:36:25 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker(
  $version      = installed,
  $package_name = 'docker-io',
  $service_name = 'docker',
) {
  $options = hiera_array('docker::options',[])

  class { 'install':  }
  ->
  class { 'config':   }
  ->
  class { 'services': }

  contain docker::install
  contain docker::config
  contain docker::services
}
