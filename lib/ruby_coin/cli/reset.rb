# frozen_string_literal: true
module RubyCoin
  module Cli
    class Reset < Hanami::CLI::Command
      desc 'clear blockchain'
      def call(*)
        chain = RubyCoin::Chain.new(database_url: 'sqlite://data/blockchain.dev.db')
        chain.clear
      end
    end
  end
end
