#
#   Author: Rohith
#   Date: 2014-10-16 23:38:07 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class docker::registry::config {
  file {
    '/etc/registry':
      ensure  => directory,
      mode    => '0550';

    '/etc/registry/config.yml':
      ensure  => 'link',
      target  => '/usr/local/lib/python2.7/dist-packages/config/config.yml',
      require => File['/etc/registry'];

    '/usr/local/lib/python2.7/dist-packages/config/config.yml':
      mode    => '0440',
      content => template("${module_name}/registry/config.yml.erb");

    $docker::registry::storage_path:
      ensure  => directory,
      mode    => '0770';
  }
}
