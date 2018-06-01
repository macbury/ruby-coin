# frozen_string_literal: true

module RubyCoin
  module Validation
    class Block
      extend Dry::Initializer
      option :hasher, default: -> { Hasher.new }

      def valid?(block)
        result = Schema::Block.call(block.to_h)
        return false unless result.success?

        hasher.with(block.to_h.except(:hash, :nonce))
        hash = hasher.calculate(nonce: block.nonce)
        block.hash == hash
      end
    end
  end
end
