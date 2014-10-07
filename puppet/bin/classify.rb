#!/usr/bin/env ruby
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-06 16:48:37 +0100 (Mon, 06 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
require 'yaml'
require 'optionscrapper'
require 'deep_merge'

module Classification
  class CLI
    def initialize
      begin
        parser.parse!
        send options[:command] if options[:command]
      rescue SystemExit => e
        exit e.status
      rescue Exception => e
        parser.usage e.message
      end
    end

    private
    def define
      raise ArgumentError, "you have not specified a hostname to classify" unless options[:hostname]
      raise ArgumentError, "the hostname: #{options[:hostname]} is invalid" unless hostname? options[:hostname]
      verbose "define: attemping to classify hostname: '#{options[:hostname]}'"
      classify options[:hostname] do |node|
        puts node.to_yaml
      end
    end

    def list
      # step: set the defaults
      options[:hostname]  ||= '.*'
      verbose "list: generating classification fro all nodes: regex: '#{options[:regex]}'"
      classify options[:hostname], true do |node|
        puts node.to_yaml
      end
    end

    def classify hostname, regex = false
      # step: iterate the nodes
      list = []
      verbose "classify: hostname: #{hostname}"
      nodes hostname, regex do |name,definition|
        verbose "classify: name: #{name}, definition: #{definition}"
        host = {}
        # step: do we have any groups we need to merge?
        if definition.has_key? 'groups'
          definition['groups'].each do |x|
            host.deep_merge!( groups[x] || {} )
          end
        end
        # step: merge the definition into the host config
        host.deep_merge!(definition)
        # step: delete the groups
        host.delete 'groups'
        # step: yield if required
        yield host if block_given?
        list << host
      end
      list
    end

    def nodes hostname, regex = false
      raise ArgumentError, "yopu have not passed a block" unless block_given?
      (classification['nodes'] || {}).each_pair do |k,v|
        yield k,v if hostname[/#{k}/] and !regex
        yield k,v if k[/#{hostname}/] and regex
      end
    end

    def groups
      classification['groups']
    end

    def classification
      verbose "classify: using the configuration file: #{config}"
      @classification ||= nil
      unless @classification
        raise ArgumentError, 'you have not specified a classification file' unless config
        raise ArgumentError, "the configuration: #{config} does not exists" unless File.exists? config
        raise ArgumentError, "the configuration: #{config} is not readable" unless File.readable? config
        @classification = YAML.load(File.read(config))
      end
      yield @classification if block_given?
      @classification
    end

    def verbose message
      puts "[verb] %s" % [ message ] if options[:verbose]
    end

    def hostname? name
      name =~ /(^[[:alpha:]\-]*)([0-9]+)/
    end

    def options
      @options ||= {
        :config  => '/etc/puppet/classification.yaml',
        :verbose => false
      }
    end

    def config
      options[:config]
    end

    def parser
      @parser ||= OptionScrapper::new do |o|
        o.on( '-c CONFIG', '--config CONFIG', 'the path of the classification file' ) { |x| options[:config] = x }
        o.on( '-v', '--verbose', 'switch on verbose mode' ) { options[:verbose] = true }
        o.command :classify, 'classify the node based on the configuration' do
          o.command_alias :cl
          o.on( '-H HOSTNAME', '--hostname HOSTNAME', 'the hostname of the box to classify' ) { |x| options[:hostname] = x }
          o.on_command { options[:command] = :define }
        end
        o.command :list, 'generate the classification for all the nodes' do
          o.command_alias :ls
          o.on( '-r REGEX', '--regex REGEX', 'a regex to filter the ndoes on' ) { |x| options[:hostname] = x }
          o.on_command { options[:command] = :list }
        end
      end
    end
  end
end

Classification::CLI.new
