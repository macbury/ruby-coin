# frozen_string_literal: true
module RubyCoin
  module Cli
    class Genesis < Base
      desc 'Create new block chain and initialize genesis block'
      def call(*)
        account = Social::PrivateAccount.generate
        miner = Miner::Master.new(chain: application.chain, recipient: account.address)

        application.chain.clear
        block = miner.genesis_block
        application.chain << block
      end
    end
  end
end
