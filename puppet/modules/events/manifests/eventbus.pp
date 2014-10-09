#
#   Author: Rohith
#   Date: 2014-10-09 22:23:59 +0100 (Thu, 09 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class events::eventbus {
  require marathon

  $packages = hiera_array('events::eventbus::packages',[])

  package {
    $packages:
      ensure => installed;

    ['bunny']:
      ensure   => installed,
      provider => 'gem',
      require  => Package[$packages];
  }

  file {
    '/opt/events':
      ensure  => directory,
      require => [
                    Package['bunny'],
                 ];

    '/opt/events/bin':
      ensure  => directory,
      require => File['/opt/events'];

    '/opt/events/bin/events.rb':
      owner   => 'root',
      group   => 'root',
      mode    => '0550',
      source  => "puppet:///modules/${module_name}/events.rb",
      require => File['/opt/events/bin'];

    '/opt/events/bin/settings.yaml':
      mode    => '0440',
      content => template("${module_name}/events/settings.yaml.erb"),
      require => File['/opt/events/bin'];
  }
}
