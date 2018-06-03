# frozen_string_literal: true
module RubyCoin
  module Cli
    class Genesis < Base
      desc 'Create new block chain and initialize genesis block'
      def call(*)
        miner = Miner::Master.new(chain: application.chain)
        account = Social::PrivateAccount.generate
        action_builder = Social::ActionBuilder.new
        application.chain.clear
        block = miner.genesis_block([
          action_builder.coinbase(account.address)
        ])
        application.chain << block
      end
    end
  end
end
