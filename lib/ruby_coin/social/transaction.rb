# frozen_string_literal: true

module RubyCoin
  module Social
    class Transaction < Action
      attribute :amount, Types::Value
      attribute :sender, Types::PublicKey
      attribute :recipient, Types::Address
      attribute :signature, Types::Strict::String
    end
  end
end
