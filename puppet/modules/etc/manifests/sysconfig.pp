#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 15:20:14 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
define etc::sysconfig(
  $ensure   = 'present',
  $content  = undef,
  $source   = undef,
  $notified = undef,
) {

  $sysconfig_dir      = hiera('sysconfig::directory','/etc/sysconfig')
  $configuration_file = "${sysconfig_dir}/${name}"

  file {
    $configuration_file:
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      notify => $notified,
      mode   => '0444';
  }

  if $content {
    File[$configuration_file] { content => $content }
  } elsif $source {
    File[$configuration_file] { source => $source }
  } else {
    File[$configuration_file] { content => template("${caller_module_name}/sysconfig/${name}.erb") }
  }
}

