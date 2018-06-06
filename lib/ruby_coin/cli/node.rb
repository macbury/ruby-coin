# frozen_string_literal: true

require 'rack/handler/puma'

module RubyCoin
  module Cli
    class Node < Base
      desc 'start network node'
      option :full, type: :boolean, default: false, desc: 'Full node with mining new blocks'

      def call(*)
        application.roster.fetch
        # fetch nodes
        # sync blockchain(ask for blocks from index and validate them)
        # sync pending actions
        # register node
        # trigger sync balances
        # start miner
        # start new block verification
        # start on action listener
        #Thread.new { sync }
        #Thread.new { miner }
        http_server
      end

      private

      def miner
        while true
          puts "Wot?"
          sleep 1
        end
      end

      def sync

      end

      def http_server
        builder = Rack::Builder.new
        builder.use Rack::Logger, 'info'
        builder.use Rack::CommonLogger
        builder.run RubyCoin::Node::Api
        Rack::Handler::Puma.run(builder, {
          Port: 7000
        })
      end
    end
  end
end
