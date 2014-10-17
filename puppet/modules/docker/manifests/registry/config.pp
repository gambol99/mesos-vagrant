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

    [ '/var/log/docker-registry', '/var/run/docker-registry' ]:
      ensure  => directory,
      mode    => '0770';
  }

  etc::initd { 'docker-registry':
    source  => "puppet:///modules/${module_name}/init.d/docker-registry",
  }

  etc::sysconfig { 'docker-registry':
    content => template("${module_name}/registry/docker-registry.erb"),
  }
}
