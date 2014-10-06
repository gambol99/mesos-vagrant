#!/usr/bin/env ruby
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-06 16:48:37 +0100 (Mon, 06 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
require 'yaml'
require 'optionscrapper'
require 'colorize'

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
    def classify
      raise ArgumentError, "you have not specified a hostname to classify" unless options[:hostname]
      verbose "classify: attemping to classify hostname: '#{options[:hostname]}'"
      classification options[:hostname] do |cfg|
        puts cfg.to_yaml if cfg and cfg.is_a? Hash
      end
    end

    def classification hostname
      host = {}
      nodes.each do |filter,data|
        # step: take the node regex and apply against hostname
        if hostname =~ /#{filter}/
          verbose "found classification for host: #{hostname}, filter: #{filter}, data: #{data}"
          # step: does the config have any groups
          if data.has_key? 'group'

        end
      end
      yield host_classification if block_given?

    end

    def nodes
      load_classification['nodes'].each_pair { |k,v| yield k,v } if block_given?
      load_classification['nodes']
    end

    def load_classification
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
      puts "[verb] %s".green % [ message ] if options[:verbose]
    end

    def options
      @options ||= {
        :config  => './classification.yaml',
        :verbose => true
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
          o.on( '-h HOSTNAME', '--hostname HOSTNAME', 'the hostname of the box to classify' ) { |x| options[:hostname] = x }
          o.on_command { options[:command] = :classify }
        end
      end
    end
  end
end

Classification::CLI.new
