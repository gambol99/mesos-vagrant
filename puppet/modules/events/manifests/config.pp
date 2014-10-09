#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-09 12:36:58 +0100 (Thu, 09 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class events::config {
  rabbitmq_user { 'admin':
    admin    => true,
    password => 'admin',
    tags     => ['admin'],
  }
  rabbitmq_user { 'events':
    admin    => false,
    password => ''
  }
  ->
  rabbitmq_vhost { 'events':
    ensure => present,
  }
  ->
  rabbitmq_user_permissions { 'events@events':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
