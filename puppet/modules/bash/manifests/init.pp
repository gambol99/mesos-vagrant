#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-07 15:51:49 +0100 (Tue, 07 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
class bash {
  ensure_packages(['bash'])

  etc::profiled {
    "bash":
      source => "puppet:///modules/bash/profile.d/bash.sh";
    "bash-console":
      source => "puppet:///modules/bash/profile.d/bash-console.sh";
  }
}

