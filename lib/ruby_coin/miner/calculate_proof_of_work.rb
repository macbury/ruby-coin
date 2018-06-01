# frozen_string_literal: true

require 'socket'

module RubyCoin
  module Miner
    class CalculateProofOfWork < Worker
      extend Dry::Initializer

      option :hasher, default: -> { Crypto::Hasher.new }

      def perform(options)
        puts options.inspect
        difficulty_prefix = '0' * options['index']
        hasher.with(options.except('ranges'))

        options['ranges'].each do |nonce|
          hash = hasher.calculate(nonce: nonce)
          return [hash, nonce] if hash.start_with?(difficulty_prefix)
        end
        false
      end
    end
  end
end
