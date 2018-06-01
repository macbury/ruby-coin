# frozen_string_literal: true
module RubyCoin
  module Cli
    class Genesis < Hanami::CLI::Command
      desc 'Create new block chain and initialize genesis block'
      def call(*)
        chain = RubyCoin::Chain.new(database_url: 'sqlite://data/blockchain.dev.db')
        miner = RubyCoin::Miner::Master.new(chain: chain)

        chain.clear
        chain << miner.genesis_block
      end
    end
  end
end
