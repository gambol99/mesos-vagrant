#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-08 14:12:00 +0100 (Wed, 08 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
module Puppet::Parser::Functions
  newfunction( :mesos_property, :type => :rvalue ) do |args|
    raise( Puppet::ParseError, "mesos_property(): Wrong number of arguments given (#{args.size} for 1)") unless args.size == 1
    raise( Puppet::ParseError, "mesos_property(): first argument should be a Hash") unless args.first.is_a? Hash
    options   = args.first
    resources = {}
    debug "mesos_property() options: #{options}"
    options.keys.sort.each do |x|
      # step: if the value is not a has, we assume value property
      if !options[x].is_a? Hash
        resources[x] = { :value => options[x] }
      elsif options.is_a? Hash
        resources[x] = {}.merge!( options[x] )
      end
    end
    debug "mesos_property() resources: #{resources}"
    resources
  end
end
