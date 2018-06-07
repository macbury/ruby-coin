# frozen_string_literal: true

module RubyCoin
  module Social
    class Transaction < Action
      attribute :amount, Types::Value
      attribute :sender, Types::PublicKey
      attribute :recipient, Types::Address
      attribute :signature, Types::Strict::String

      # Check if message is properly signed
      # @return [Boolean]
      def valid_signture?
        PublicAccount.new(public_key: sender).verify(signature, ordered_data([:signature]))
      end
    end
  end
end
