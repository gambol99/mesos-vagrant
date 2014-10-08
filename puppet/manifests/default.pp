#
#   Author: Rohith (gambol99@gmail.com)
#
#  vim:ts=4:sw=4:et

filebucket {
  main:
    server => "puppet"
}

Exec {
  path      => "/usr/bin:/usr/sbin/:/bin:/sbin",
  timeout   => 20,
  logoutput => true
}

Service {
  ensure     => 'running',
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
}

File {
  backup   => main,
  checksum => md5,
  owner    => 'root',
  group    => 'root',
  ensure   => file,
  force    => false,
  ignore   => [
                ".svn",
                ".git",
                "CVS",
                "genconf.sh",
                "deploy.sh",
                "checkconf.sh",
                "Makefile"
                ],
  recurse  => false
}

Mailalias {
  notify => Exec["newaliases"]
}

Tidy {
  recurse => false,
  type    => ctime
}

User {
  allowdupe => false
}

Group {
  allowdupe => false
}

$server = "puppet"

case $::architecture {
  x86_64,amd64: { $lib = "lib64" }
  i386:         { $lib = "lib"   }
  default:      { fail("Shite: Architecture was not detected correctly, aborting...") }
}
