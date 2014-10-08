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

gem_install() {
  GEM_FILE="$@"
  if ! gem list | grep -q $GEM_FILE; then
    say "Installing GEM $GEM_FILE"
    gem install --no-rdoc --no-ri -V $GEM_FILE
  fi
}

install_puppet() {
  if centos; then
    if centos6; then
      if [ ! -f "/etc/yum.repos.d/puppetlabs.repo" ]; then
        say "Installing Puppet"
        sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
      fi
    else
      if [ ! -f "/etc/yum.repos.d/puppetlabs.repo" ]; then
        say "Installing Puppet"
        sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
      fi
    fi
    yum update -y puppet
  elif ubuntu; then
    say "Installing Puppet for Ubuntu"
    sudo wget -q https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
    sudo dpkg -i puppetlabs-release-trusty.deb
    sudo apt-get update
    sudo apt-get install -y puppet
    sudo apt-get install -y --no-install-recommends --force-yes --only-upgrade puppet 2>/dev/null
  fi
  say "Puppet Verion: `puppet --version`"
}

install_puppet

say "Installing the dependencies"
gem_install deep_merge
gem_install optionscrapper

say "Puppet Apply"
puppet apply /etc/puppet/manifests/default.pp
