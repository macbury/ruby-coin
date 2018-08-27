# frozen_string_literal: true

module RubyCoin
  module Social
    # Actions that wait to be added to blockchain
    class PendingActions
      def initialize(chain:)
        @actions = Concurrent::Array.new
        @chain = chain
      end

      def push(action)
        return if exists?(action)
        validator.validate!(action)
        @actions << action
        true
      end

      def candidates_for_block
        # iterate over actions
        # check if transaction can withdraw required amount of money from account
        # select it to block
        10.times.map { @actions.pop }.compact
      end

      # Check if transaction with hash exists
      # @param hash [String]
      def exists?(hash)
        @actions.any? { |action| action.hash == hash }
      end

      private

      def validator
        @validator ||= Validation::Action.new(allow_coinbase: false, chain: @chain)
      end
    end
  end
end
