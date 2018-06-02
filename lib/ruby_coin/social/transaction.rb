# frozen_string_literal: true

module RubyCoin
  module Social
    class Transaction < Dry::Struct
      COIN_REWARD = 50
      transform_keys(&:to_sym)

      attribute :id, Types::String.optional.default { SecureRandom.hex(3) }
      attribute :value, Types::Value
      attribute :recipient, Types::PublicKey.optional.default { '' }

      # Create coinbase transaction with reward for mining a block
      # @return [Transaction]
      def self.coinbase
        new(value: COIN_REWARD)
      end
    end
  end
end
