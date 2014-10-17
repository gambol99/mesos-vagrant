#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-17 10:25:52 +0100 (Fri, 17 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
define etc::initd(
  $ensure  = 'present',
  $content = undef,
  $source  = undef,
) {
  $configuration_file = "/etc/init.d/${name}"

  file {
    $configuration_file:
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0555';
  }

  if $content {
    File[$configuration_file] { content => $content }
  } elsif $source {
    File[$configuration_file] { source => $source }
  } else {
    File[$configuration_file] { content => template("${caller_module_name}/init.d/${name}.erb") }
  }
}
