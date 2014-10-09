#
#   Author: Rohith
#   Date: 2014-10-09 22:13:45 +0100 (Thu, 09 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class events::rabbitmq {
  # step: create the rabbitmq users
  create_resources( 'rabbitmq_user', $events::rabbitmq_users )

  rabbitmq_vhost { 'events':
    ensure => present,
  }
  ->
  rabbitmq_user_permissions { 'events@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
