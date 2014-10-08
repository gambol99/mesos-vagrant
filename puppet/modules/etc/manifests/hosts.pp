#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 14:13:20 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class etc::hosts {
  $host_entries = hiera_hash('etc::hosts::entries',{})

  exec { "/etc/hosts remove $hostname/$fqdn from 127.0.0.1":
    command => "/bin/sed -i -e '/127.0.[10].1.*${hostname}/d' -e '/^#/d' /etc/hosts",
    onlyif  => "/bin/egrep -q '^127.0.[10].1.*${hostname}' /etc/hosts",
  }
  ->
  host { 'localhost.localdomain':
    ip           => '127.0.0.1',
    host_aliases => 'localhost';
  }
  host { $fqdn:
    ip           => $ipaddress,
    host_aliases => "$hostname";
  }
  create_resources( Host, $host_entries )
}
