# frozen_string_literal: true

module RubyCoin
  module Validation
    class Block
      extend Dry::Initializer
      option :hasher, default: -> { Hasher.new }

      # Check if block content is valid
      # @param block [Block]
      # @return [Boolean]
      def valid?(block)
        result = Schema::Block.call(block.to_h)
        return false unless result.success?
        return false if block.actions.select { |action| action.is_a?(Social::Coinbase) }.size > 1

        hasher.prepare(block.to_h.except(:hash, :nonce, :actions).merge(data: block.merkle_tree.root.hash))
        hash = hasher.calculate(nonce: block.nonce)
        block.hash == hash
      end
    end
  end
end
