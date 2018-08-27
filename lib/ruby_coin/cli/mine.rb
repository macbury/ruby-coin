# frozen_string_literal: true

module RubyCoin
  module Cli
    class Mine < Base
      argument :recipient, required: true, desc: 'Address that receives coins for mined block'
      option :genesis, type: :boolean, default: false, desc: 'Initialize genesis block and start mining from it'

      desc 'start mining random blocks'
      def call(recipient:, genesis:)
        miner = Miner::Master.new(chain: application.chain, recipient: recipient)

        if genesis
          chain.clear
          block = miner.genesis_block
          chain << block
          puts "Genesis block: #{block.index} with #{block.hash}"
        end

        if chain.empty?
          puts 'Blockchain is empty..., Run mining with genesis flag'
          return
        end

        loop do
          block = miner.mine([])
          if block
            chain << block
            puts "New block: #{block.index} with #{block.hash}"
          end
        end
      end
    end
  end
end
