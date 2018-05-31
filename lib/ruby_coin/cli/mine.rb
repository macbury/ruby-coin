# frozen_string_literal: true
module RubyCoin
  module Cli
    class Mine < Hanami::CLI::Command
      desc 'start mining random blocks'

      def call(*)
        chain = RubyCoin::Chain.new({ database_url: 'sqlite://data/blockchain.dev.db' })
        blockchain = RubyCoin::Blockchain.new(chain: chain)

        loop do
          block = blockchain << { index: 's' }
          puts "New block: #{block.index} with #{block.hash}"
        end
      end
    end
  end
end
