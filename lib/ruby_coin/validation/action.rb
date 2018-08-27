# frozen_string_literal: true

module RubyCoin
  module Validation
    class Action
      extend Dry::Initializer
      option :allow_coinbase
      option :chain

      # Check if action can be appended to blockchain
      # @param action [Social::Action]
      # @raise [Errors::ValidationError]
      def validate!(action)
        raise Errors::InvalidAction, ['Action happened in future...'] if action.time > Time.now.utc
        if action.is_a?(Social::Coinbase)
          validate_coinbase(action)
        elsif action.is_a?(Social::Transaction)
          validate_transaction(action)
        else
          raise Errors::InvalidAction, ['Action not supported']
        end
      end

      private

      # @param coinbase [Social::Coinbase]
      # @return [Boolean]
      def validate_coinbase(coinbase)
        raise Errors::InvalidAction, ['Coinbase rejected']
      end

      # @param transaction [Social::Transaction]
      # @return [Boolean]
      def validate_transaction(transaction)
        raise Errors::InvalidTransaction, ['Invalid hash'] unless transaction.valid_hash?
        raise Errors::InvalidTransaction, ['Invalid signature'] unless transaction.valid_signture?
        raise Errors::InvalidTransaction, ['Transaction already exists'] if chain.find_action(transaction.hash)
      end
    end
  end
end
