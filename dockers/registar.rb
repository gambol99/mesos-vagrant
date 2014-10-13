#!/usr/bin/env ruby
#
require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'docker-api', :require => 'docker'
require 'docker'
require 'optionscrapper'
require 'logger'
require 'zookeeper'
require 'etcd'
require 'yaml'
require 'pp'
require 'json'

module Registar
  module Docker
    def containers &block
      raise ArgumentError, "you have not specified a block" unless block_given?
      ::Docker::Container.all.each do |docker|
        yield ::Docker::Container.get( docker.id )
      end
    end
  end

  module Backends
    class Backend
      attr_reader :uri
      def initialize connection
        @uri  = connection
      end
    end

    class Zookeeper < Backend
      def get_connection
        ::Zookeeper.new( uri )
      end

      def set path, data, ttl = nil
        zookeeper_pathway path
        zookeeper.set path: path, data: data
      end

      def zookeeper
        @zookeeper ||= get_connection
        @zookeeper = get_connection unless @zookeeper.connected?
      end

      def zookeeper_pathway path
        path_root = ""
        # step: remove any preceeeding slashes
        zookeeper_path = path.gsub(/^\/+/,'')
        zookeeper_path.split('/').each do |x|
          path_root << "/#{x}"
          children = zookeeper.get_children( path: path_root )
          zookeeper.create path: path_root if children[:children].nil?
        end
      end
    end

    class Etcd < Backend
      def get_connection
        ::Etcd.client( host: uri, port: 49153 )
      end

      def set path, data, ttl = nil
        @etcd ||= get_connection
        @etcd.set path, value: data, ttl: ttl, recursive: true if ttl
        @etcd.set path, value: data, recursive: true unless ttl
      end
    end
  end

  module Discovery
    include Backends

    def set path, value, ttl = nil
      @backend ||= nil
      unless @backend
        @backend ||= load_backend settings['backend']
        @backend
      end
      @backend.set path, value, ttl
    end

    private
    def load_backend backend = options['backend']
      case backend
      when 'zookeeper'
        Registar::Backends::Zookeeper.new settings['uri']
      when 'etcd'
        Registar::Backends::Etcd.new( settings['uri'] )
      else
        raise ArgumentError, "load_backend: unknown backend: #{backend}"
      end
    end
  end

  module Utils
    def split_array list, symbol = '='
      list.inject({}) do |map,element|
        elements = element.split symbol
        if elements.size > 0
          map[elements.first] = elements.last
        end
        map
      end
    end

    %w(info warn error debug).each do |x|
      define_method x.to_sym do |message|
        log.send x.to_sym, message if options['verbose']
      end
    end

    def log
      @logger ||= nil
      unless @logger
        @logger ||= Logger.new STDOUT
        @logger.level = Logger::DEBUG
      end
      @logger
    end
  end

  class Service
    include Docker
    include Utils
    include Zookeeper
    include Discovery

    def initialize
      begin
        parser.parse!
        send options[:command] if options[:command]
      rescue SystemExit => e
        exit e.status
      rescue SignalException => e
        exit 0
      rescue Exception => e
        parser.usage e.message
      end
    end

    private
    def run
      # step: start the event loop
      debug 'run: starting the event loop'
      loop do
        debug 'run: starting a iteration'
        begin
          # step: iterate the containers and push into service discovery
          containers do |x|
            debug "run: container found, id: #{x.id} DOCKER"
            # step: generate the container service path
            path = service_path x
            debug "run: path: #{path}"
            # step: ignore any container that we cannot build a service path on
            next unless path
            # step: extract the details for service discovery
            service = service_info x
            # step: add the service to the path
            debug "\npath: #{path}\nservice: #{PP.pp(service,'')}"
            # step: push into service discovery
            set path, service.to_json, settings['ttl']
          end
        rescue SystemExit => e
          exit e.status
        end
        # step: lets go to sleep
        sleep_time = settings['interval'] * 0.001
        debug "run: about to got to sleep for #{sleep_time} seconds"
        sleep sleep_time
      end
      debug 'run: the event loop has ended'
    end

    # service_path: prefix/<environment>/<name>/<hostname>
    def service_path docker
      path = "#{settings['prefix']}"
      # step: get the environment variables
      environment = split_array( docker.info['Config']['Env'] || {} )
      # step: if the container does not have a APP env we ignore it
      return nil unless environment.has_key? 'APP'
      # step: extract the details from environment
      %w(ENVIRONMENT APP NAME).each do |e|
        path << "/#{environment[e]}" if environment.has_key? e
      end
      # step: add the hostname to the end
      path << "/" << docker.info['Config']['Hostname']
      # step: hand back the path
      path
    end

    def service_info docker
      config    = docker.info
      service = {
        :id         => docker.id,
        :updated    => Time.now.to_i,
        :image      => config['Image'],
        :domain     => config['Domainname'] || '',
        :entrypoint => config['Entrypoint'] || '',
        :volumes    => config['Volumes'] || {},
        :state      => config['State']['Running'],
        :docker_pid => config['State']['Pid'] || 0,
        :ports      => config['NetworkSettings']['Ports'] || {}
      }
      service
    end

    def options
      @options ||= {}
    end

    def settings
      @settings ||= load_configuration
    end

    def load_configuration
      configuration = {}
      configuration = ( YAML.load(File.read(options['config'])) || {} ) if options['config']
      configuration.merge!( default_configuration )
      # step: merge the commnad line options to override the config if required
      configuration.merge!( options )
    end

    def default_configuration
      {
        'docker'    => 'unix:///var/run/docker.sock',
        'interval'  => 5000,
        'prefix'    => '/services',
        'backend'   => 'zookeeper',
        'ttl'       => 10,
        'uri'       => 'localhost:2181',
        'verbose'   => false,
      }
    end

    def parser
      @parser ||= OptionScrapper::new do |o|
        o.on( '-c CONFIG', 'the path to the configuration file' ) { |x| options['config'] = x }
        o.on( '-v', '--verbose', 'switch on verbose logging' ) { options['verbose'] = true }
        o.on( '-B BACKEND', '--backend BACKEND', 'the backend to use for service discovery') { |x| options['backend'] = x }
        o.command :run, 'perform the events stream for service discovery' do
          o.on( '-u URI', '--uri URI', 'the connection uri for zookeeper/etcd') { |x| options['uri'] = x }
          o.on( '-i INTERVAL', '--interval INTERVAL', 'the interval time between pushing data into service discovery' ) { |x| options['interval'] = x.to_i }
          o.on( '-p PREFIX', '--prefix PREFIX', 'the prefix for adding data to service discovery' ) { |x| options['prefix'] = x }
          o.on( '-P PORT', '--port PORT', 'the port to use for service discovery' ) { |x| options['port'] = x }
          o.on( '-t TTL', '--ttl TTL', 'the time to live for services pushed into service discovery' ) { |x| options['ttl'] = x.to_i }
          o.on_command { options[:command] = :run }
        end
      end
    end
  end
end

Registar::Service.new
