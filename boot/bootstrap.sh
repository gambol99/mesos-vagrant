#!/bin/bash
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-06 15:49:22 +0100 (Mon, 06 Oct 2014)
#
#  vim:ts=2:sw=2:et
#

CENTOS_VERSION="/etc/redhat-release"

say() {
  echo "** $@"
}

centos() {
  [ -f /etc/redhat-release ] && return 0 || return 1
}

centos6() {
  grep -q 'CentOS release 6' $CENTOS_VERSION 2>/dev/null && return 0 || return 1
}

centos7() {
  grep -q 'CentOS Linux release 7' $CENTOS_VERSION 2>/dev/null && return 0 || return 1
}

ubuntu() {
  uname -a | grep -q Ubuntu && return 0 || return 1
}

install_puppet() {
  if centos; then
    if centos6; then
      if [ ! -f "/etc/yum.repos.d/puppetlabs.repo" ]; then
        cat > /etc/yum.repos.d/puppetlabs.repo <<EOF
[puppetlabs-products]
name=Puppet Labs Products El 6
baseurl=http://yum.puppetlabs.com/el/6.4/products/x86_64/
gpgcheck=0
enabled=1

[puppetlabs-deps]
name=Puppet Labs Dependencies El 6
baseurl=http://yum.puppetlabs.com/el/6.4/dependencies/x86_64/
gpgcheck=0
enabled=1
EOF
      fi
    else
      if [ ! -f "/etc/yum.repos.d/puppetlabs.repo" ]; then
        cat > /etc/yum.repos.d/puppetlabs.repo <<EOF
[puppetlabs-products]
name=Puppet Labs Products El 7
baseurl=http://yum.puppetlabs.com/el/7/products/x86_64/
gpgcheck=0
enabled=1

[puppetlabs-deps]
name=Puppet Labs Dependencies El 7
baseurl=http://yum.puppetlabs.com/el/7/dependencies/x86_64/
gpgcheck=0
enabled=1
EOF
      fi
    fi
  elsif ubuntu
    wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
    sudo dpkg -i puppetlabs-release-precise.deb
    sudo apt-get update
    sudo apt-get install -y puppet
  fi
}

say "Installing Puppet"
install_puppet

say "Installing the dependencies"
gem install --no-rdoc --no-ri -V deep_merge
gem install --no-rdoc --no-ri -V optionscrapper

say "Puppet Apply"
puppet apply /etc/puppet/manifests/default.pp
