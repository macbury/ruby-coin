# frozen_string_literal: true

require 'rack/handler/puma'

module RubyCoin
  module Cli
    class Node < Base
      desc 'start network node'
      option :genesis, type: :boolean, default: false, desc: 'Initialize genesis block and start mining from it'
      option :recipient, required: true, desc: 'Address that receives coins for mined block'

      def call(genesis:, recipient:)
        logger.info 'Finding peers...'
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
        Thread.new { start_mining(genesis, recipient) } if recipient
        http_server
      end

      private

      def start_mining(genesis, recipient)
        logger.info 'Starting mining'
        miner = Miner::Master.new(chain: application.chain, recipient: recipient)
        if genesis
          chain.clear
          block = miner.genesis_block
          chain << block
          logger.info "Genesis block: #{block.index} with #{block.hash}"
        end

        if chain.empty?
          logger.info 'Blockchain is empty..., Run mining with genesis flag'
          exit 0
        end

        loop do
          block = miner.mine(application.pending_actions.candidates_for_block)
          if block
            chain << block
            logger.info "New block: #{block.index} with #{block.hash}"
          end
        end
      end

      def sync

      end

      def http_server
        logger.info 'Starting api server...'
        builder = Rack::Builder.new
        builder.use Rack::CommonLogger, application.logger
        builder.run RubyCoin::Node::Api
        Rack::Handler::Puma.run(builder, {
          Host: '0.0.0.0',
          Port: 7000
        })
      end
    end
  end
end
