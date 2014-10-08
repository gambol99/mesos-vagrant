#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-08 12:19:59 +0100 (Wed, 08 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
module Puppet::Parser::Functions
  newfunction( :maratron_param, :type => :rvalue ) do |args|
    raise( Puppet::ParseError, "maratron_param(): Wrong number of arguments given (#{args.size} for 1)")   unless args.size == 1
    raise( Puppet::ParseError, "maratron_param(): first argument should be a Hash")   unless args.first.is_a? Hash
    options   = args.first
    resources = {}
    debug "maratron_param() options: #{options}"
    options.keys.sort.each do |x|
      next if options[x].nil?
      resources[x] = { :value => options[x] }
    end
    debug "maratron_param() resources: #{resources}"
    resources
  end
end
