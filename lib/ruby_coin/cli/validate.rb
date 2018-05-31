# frozen_string_literal: true
module RubyCoin
  module Cli
    class Validate < Hanami::CLI::Command
      desc 'full blockchain validation'

      def call(*)
        chain = RubyCoin::Chain.new({ database_url: 'sqlite://data/blockchain.dev.db' })
        blockchain = RubyCoin::Blockchain.new(chain: chain)

        if blockchain.valid?
          puts 'Blockchain is valid'
        else
          puts 'Blockchain is broken'
        end
      end
    end
  end
end
