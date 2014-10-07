#
#   Author: Rohith
#   Date: 2013-12-10 14:57:41 +0000 (Tue, 10 Dec 2013)
#
#  vim:ts=4:sw=4:et
#
require 'yaml'
Classification = '/etc/puppet/classification.yaml'
TOKENS = {
  :CLASSES        => 'classes',
  :NODES          => 'nodes',
  :CONFIG         => 'config',
  :CLUSTER_NAME   => 'cluster_name',
  :CLUSTER_CLASS  => 'cluster_class',
  :NODEID         => 'nodeid',
  :HOSTNAME       => 'hostname',
  :DATACENTER     => 'datacenter'
}

module Puppet::Parser::Functions
  newfunction( :cluster, :type => :rvalue ) do |args|
    raise( Puppet::ParseError, "cluster(): Wrong number of arguments given (#{args.size} for 2)")   unless args.size == 1
    options = args[0]
    [ TOKENS[:CLUSTER_CLASS] ].map do |x|
      #raise( Puppet::ParseError, "cluster(): You have not passed us the %s field") unless options.has_key? x
      raise Exception, "cluster(): You have not passed us the %s field" % [ x ] unless options.has_key? x
    end
    cluster_class = options[ TOKENS[:CLUSTER_CLASS] ]
    cluster_name  = options[ TOKENS[:CLUSTER_NAME] ] || nil
    config = {
      TOKENS[:NODES]  => [],
      TOKENS[:CONFIG] => {}
    }
    raise( Puppet::ParseError, "cluster(): The cluster class looks invalid to me") unless cluster_class =~ /^[[:alpha:]\:]*$/
    if cluster_name
      raise( Puppet::ParseError, "cluster(): The cluster name %s looks invalid to me" % [ cluster_name ] )  unless cluster_name  =~ /^[[:alpha:]]+$/
    end
    if File.exists? Classification and File.readable? Classification
      begin
        classifiy = YAML.load_file Classification
        nodes     = classifiy[ TOKENS[:NODES] ]
        nodes.each_pair do |name,node|
          classes = node[ TOKENS[:CLASSES] ] || {}
          debug "cluster: node: #{name}, cluster_name: #{cluster_name}, cluster_class: #{cluster_class}, in classes: #{classes}"
          if classes.has_key?( cluster_class ) 
            # check: we have passed a cluster name, lets make sure the class has the cluster_name inside
            if cluster_name 
              next unless classes[ cluster_class ].has_key? TOKENS[:CLUSTER_NAME]
              next unless classes[ cluster_class ][TOKENS[:CLUSTER_NAME]] == cluster_name
            end
            # lets ignore the node if it doesn't match our expectations
            next unless name =~ /([a-z\-]*([0-9]{3})-([[:alnum:]]{3,7}))/
            hostname, nodeid, datacenter = $1, $2, $3
            # check: if they have supplied a datacenter filter, we need to filter out the DC not related
            if config[TOKENS[:DATACENTER]]
              next if config[TOKENS[:DATACENTER]] == $3
            end
            config[TOKENS[:NODES]] << name
            node_cfg = {}.merge!( classes[cluster_class] )
            node_cfg[TOKENS[:HOSTNAME]]     = hostname
            node_cfg[TOKENS[:NODEID]]       = nodeid
            node_cfg[TOKENS[:DATACENTER]]   = datacenter
            config[TOKENS[:CONFIG]][name]   = node_cfg
          end
        end
      rescue Exception => e
        raise( Puppet::ParseError, "cluster(): exception caught, message: %s" % [ e.message ] ) 
        #raise Exception, "cluster(): exception caught, message: %s" % [ e.message ] 
      end
    end
    debug "cluster: config: #{config}"
    config
  end
end
