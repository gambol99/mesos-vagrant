#
#   Author: Rohith
#   Date: 2014-10-16 23:38:09 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::registry::install {
  package {
    $docker::registry::package_deps:
      ensure  => installed;

    'docker-registry':
      ensure    => $docker::registry::version,
      provider  => 'pip',
      require   => Package[$docker::registry::package_deps],
  }
}
