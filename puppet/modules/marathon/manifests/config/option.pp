define marathon::config::option(
  $ensure   = 'present',
  $value    = undef,
  $content  = undef,
  $source   = undef,
  $notified = Service['marathon'],
) {

  $configuration_file = "/etc/marathon/conf/${name}"

  file {
    $configuration_file:
      ensure => $present,
      mode   => '0440',
      notify => $notified;
  }

  if $content {
    File[$configuration_file] { content => $content }
  } elsif $source {
    File[$configuration_file] { source  => $source }
  } elsif $value {
    File[$configuration_file] { content => inline_template("<%=@value%>\n") }
  } else {
    fail("${caller_module_name}: you have not specified the content or source")
  }
}
