# frozen_string_literal: true

module RubyCoin
  module Validation
    class Chain
      extend Dry::Initializer
      option :hasher, default: -> { Crypto::Hasher.new }

      # Check if block chain is valid
      # @param block [Chain]
      # @return [Boolean]
      def valid?(chain)
        prev_block = nil
        chain.each do |block|
          if (prev_block.nil? || block.after?(prev_block)) && block_validator.valid?(block)
            prev_block = block
            next
          end
          return false
        end
        true
      end

      private

      def block_validator
        @block_validator ||= Block.new(hasher: hasher)
      end
    end
  end
end
