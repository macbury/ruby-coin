# frozen_string_literal: true
module RubyCoin
  module Cli
    class Print < Hanami::CLI::Command
      desc 'print all blocks'

      def call(*)
        chain = RubyCoin::Chain.new({ database_url: 'sqlite://data/blockchain.dev.db' })
        
        Terminal::Table.new do |table|
          table << ['Index', 'Hash', 'Nonce', 'Time', 'Data']
          table.add_separator
          chain.each do |block|
            table << [block.index, block.hash, block.nonce, block.time, block.data]
          end
          puts table
        end
      end
    end
  end
end
