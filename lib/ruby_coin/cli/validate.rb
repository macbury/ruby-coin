# frozen_string_literal: true
module RubyCoin
  module Cli
    class Validate < Base
      desc 'full blockchain validation'
      def call(*)
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
