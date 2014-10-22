#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 15:52:38 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
define etc::profiled (
  $ensure   = present,
  $content  = undef,
  $source   = undef,
  $required = undef
) {
  $configuration_file = "/etc/profile.d/${name}.sh"

  file { $configuration_file:
    ensure  => $ensure,
    mode    => '0555',
  }
  if $content {
    File[$configuration_file] { content => $content }
  } elsif $source {
    File[$configuration_file] { source => $source }
  } else {
    File[$configuration_file] { content => template("${caller_module_name}/profile.d/${name}.erb") }
  }
}

