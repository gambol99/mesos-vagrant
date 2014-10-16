#
#   Author: Rohith
#   Date: 2014-10-16 21:26:15 +0100 (Thu, 16 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
require 'facter'

hostname=`hostname`.chomp
if hostname =~ /^([[:alpha:]\-]*)([[:digit:]]{3})*/
  role = $1
  Facter.add('role') do
    setcode do
      role
    end
  end
end
