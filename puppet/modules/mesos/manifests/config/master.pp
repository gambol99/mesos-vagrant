define mesos::config::master(
  $ensure   = 'present',
  $value    = undef,
  $content  = undef,
  $source   = undef,
  $notified = []
) {
  mesos::config::option { $name:
    type     => 'master',
    ensure   => $ensure,
    value    => $value,
    content  => $content,
    source   => $source,
    notified => Service['mesos-master'],
  }
}
