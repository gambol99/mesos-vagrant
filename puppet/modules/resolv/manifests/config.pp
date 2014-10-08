#
#   Author: Rohith
#   Date: 2014-10-07 23:30:38 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class resolv::config {
  file {
    '/etc/resolv.conf':
      path    => $resolv::resolver,
      mode    => '0444',
      content => template("${module_name}/resolv.conf.erb");
  }
  if $::operatingsystem == 'Ubuntu' {
    exec { '/sbin/resolvconf -u':
      refreshonly => true,
      subscribe   => File['/etc/resolv.conf'],
    }
  }
}
