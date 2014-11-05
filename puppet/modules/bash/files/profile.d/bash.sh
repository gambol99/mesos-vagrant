#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2013-07-29 16:26:58 +0100 (Mon 29 Jul 2013)
#
export HISTCONTROL=ignoredups
export HISTFILESIZE=5000
export HISTSIZE=5000
export HISTTIMEFORMAT="%F %T  "
export TERM=linux
shopt -s checkwinsize
shopt -s histappend
ulimit -c 0

# some standard aliases
alias ..="cd .."
alias ....="cd ../../"
alias s="ssh $@"
alias p="ping $@"
alias tf="tail -f /var/log/messages"
alias pa="puppet apply --pluginsync --show_diff --verbose /etc/puppet/manifests/default.pp"
