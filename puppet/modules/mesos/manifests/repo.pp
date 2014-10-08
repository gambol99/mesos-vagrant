#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 11:58:11 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class mesos::repo {
  case $::osfamily {
    'Debian': {
      if !defined(Class['apt']) {
        class { 'apt': }
      }

      $distro = downcase($::operatingsystem)

      case $source {
        undef: {} #nothing to do
        'mesosphere': {
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
          notify { "APT repository '${source}' is not supported for ${::osfamily}": }
        }
      }
    }

    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
