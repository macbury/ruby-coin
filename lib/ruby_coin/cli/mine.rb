# frozen_string_literal: true
module RubyCoin
  module Cli
    class Mine < Base
      argument :recipient, required: true, desc: 'Address that receives coins for mined block'
      desc 'start mining random blocks'
      def call(recipient:)
        miner = Miner::Master.new(chain: application.chain, recipient: recipient)
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
