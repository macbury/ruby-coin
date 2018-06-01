# frozen_string_literal: true
module RubyCoin
  module Cli
    class Validate < Hanami::CLI::Command
      desc 'full blockchain validation'
      def call(*)
        chain = RubyCoin::Chain.new(database_url: 'sqlite://data/blockchain.dev.db')
        validation = RubyCoin::Validation::Chain.new

        if validation.valid?(chain)
          puts 'Blockchain is valid'
        else
          puts 'Blockchain is broken'
        end
      end
    end
  end
end
