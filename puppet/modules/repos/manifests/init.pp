class repos {
  case $::osfamily {
    'Debian': {
      include apt
      $distro = downcase($::operatingsystem)

      apt::source { 'mesosphere':
        location    => "http://repos.mesosphere.io/${distro}",
        release     => $::lsbdistcodename,
        repos       => 'main',
        key         => 'E56151BF',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
