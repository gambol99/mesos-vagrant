define mesos::config::slave(
  $ensure   = 'present',
  $value    = undef,
  $content  = undef,
  $source   = undef,
  $notified = []
) {
  mesos::config::option { $name:
    type     => 'slave',
    ensure   => $ensure,
    value    => $value,
    content  => $content,
    source   => $source,
    notified => Service['mesos-slave'],
  }
}
