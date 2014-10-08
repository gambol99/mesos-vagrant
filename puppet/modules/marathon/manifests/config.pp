#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 18:12:17 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class marathon::config {
  file {
    '/etc/marathon':
      ensure  => directory,
      mode    => '0750';

    '/etc/marathon/conf':
      ensure  => directory,
      mode    => '0750',
      require => File['/etc/marathon'];
  }
  create_resources( 'marathon::config::option', maratron_param( $marathon::marathon_options ) )
}
