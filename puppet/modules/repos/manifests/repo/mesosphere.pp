class repos::repo::mesosphere {
  include repo
  include apt

  apt::source { 'mesosphere':
    location    => "http://repos.mesosphere.io/${distro}",
    release     => $::lsbdistcodename,
    repos       => 'main',
    key         => 'E56151BF',
    key_server  => 'keyserver.ubuntu.com',
    include_src => false,
  }
}
