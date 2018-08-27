# frozen_string_literal: true

module RubyCoin
  module Social
    class Coinbase < Action
      attribute :amount, Types::Value
      attribute :recipient, Types::Address
    end
  end
end
