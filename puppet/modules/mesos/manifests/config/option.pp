define mesos::config::option(
  $ensure   = 'present',
  $type     = 'common',
  $value    = undef,
  $content  = undef,
  $source   = undef,
  $notified = []
) {

  $configuration_file = $type ? {
    'common'    => "/etc/mesos/${name}",
    'resource'  => "/etc/mesos-slave/resources/${name}",
    'attribute' => "/etc/mesos-slave/attributes/${name}",
    default     => "/etc/mesos-${type}/${name}"
  }

  file {
    $configuration_file:
      ensure => $ensure,
      owner  => $mesos::common::owner,
      group  => $mesos::common::group,
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
