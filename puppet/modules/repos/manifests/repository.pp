define repo::repository {
  case $::osfamily {
    'Debian': {
      include apt

      $distro = downcase($::operatingsystem)

      case $source {
        undef: {} #nothing to do
        'mesosphere': {
          apt::source { 'mesosphere':
            location    => "http://repos.mesosphere.io/${distro}",
            release     => 'trusty',
            repos       => 'main',
            key         => 'E56151BF',
            key_server  => 'keyserver.ubuntu.com',
            include_src => false,
          }
        }
        default: {
          notify { "APT repository '${source}' is not supported for ${::osfamily}": }
        }
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
