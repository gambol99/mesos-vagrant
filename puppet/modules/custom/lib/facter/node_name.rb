#
#   Author: Rohith Jayawardene
#   Date: 2013-11-08 11:09:33 +0000 (Fri, 08 Nov 2013)
#
#  vim:ts=4:sw=4:et
#

require 'facter'

def add_fact( name, value )
  Facter.add( name ) do
    setcode do
      Facter.loadfacts()
      value
    end
  end
end

hostname=`hostname`
if hostname =~ /^([[:alpha:]\-]*)([[:digit:]]{3})*/
  add_fact( "nodename", $1 ) if $1
  add_fact( "nodeid",   $2 ) if $2
else
  puts "no regex match for nodename"
end
