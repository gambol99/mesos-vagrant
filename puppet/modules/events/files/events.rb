#!/usr/bin/env ruby
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2014-10-09 17:16:36 +0100 (Thu, 09 Oct 2014)
#
#  vim:ts=2:sw=2:et
#
require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'bunny'
require 'sinatra/base'
require 'logger'
require 'json'
require 'yaml'

module Marathon
  module EventBus
    class Settings
      CONFIG_FILE = File.join(File.dirname(__FILE__),'./settings.yaml')
      def self.settings
        @settings ||= YAML.load(File.read(CONFIG_FILE))
      end

      def self.[](key)
        settings[key.to_s]
      end
    end

    class Application < Sinatra::Base
      enable :logging, :static, :raise_errors
      set :port, Settings['port'] || 2047
      set :host, Settings['bind'] || '127.0.0.1'

      configure do
        uri = "amqp://%s:%s@%s:5672" % [
          Settings['exchange_username'] || 'guest',
          Settings['exchange_password'] || 'guest',
          Settings['exchange_hostname'] || 'localhost',
        ]
        topic = Settings['exchange_topic'] || 'events_streams'
        @connection = Bunny.new( uri )
        @connection.start
        @channel  = @connection.create_channel
        @exchange = @channel.topic( topic, :auto_delete => true, :durable => true, :persistent => true )
        set :exchange, @exchange
      end

      before do
        if request.body.size > 0
          @request_data = JSON.parse(request.body.read.to_s)
        end
      end

      post '/' do
        content_type :json
        debug "recieved an event from marathon: event: #{@request_data}"
        begin
          # step: we publish the event in the exchange topic, we can use the
          # taskStatus as the routing key
          if @request_data['taskStatus']
            exchange.publish @request_data.to_s, :routing_key => @request_data['taskStatus']
            info "event delivered to exchange"
          else
            warn 'the event does not appear to have a taskStatus associated'
          end
        rescue Exception => e
          error "unable to process the event: #{@request_data}, error: #{e.message}"
        end
      end

      get '/stats' do
        content_type :json
        statistics.to_json
      end

      private
      def statistics
        @statistics ||= {}
      end

      %w(event failure buffered).each do |x|
        define_method x.to_sym do
          statistics[x.to_sym] ||= 0
          statistics[x.to_sym] += 1
        end
      end

      def logger
        @logger ||= Logger.new( Settings['logfile'] || './events.log' )
      end

      %w(info error debug).each do |x|
        define_method x.to_sym do |message|
          logger.send( x.to_sym, message )
        end
      end

      def exchange
        settings.exchange
      end
    end
  end
end

Marathon::EventBus::Application.run!
