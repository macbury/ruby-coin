# frozen_string_literal: true
module RubyCoin
  module Cli
    class Genesis < Base
      desc 'Create new block chain and initialize genesis block'
      def call(*)
        miner = RubyCoin::Miner::Master.new(chain: application.chain)

        application.chain.clear
        application.chain << miner.genesis_block
      end
    end
  end
end
