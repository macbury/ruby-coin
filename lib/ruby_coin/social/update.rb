# frozen_string_literal: true

module RubyCoin
  module Social
    # Base for all operations on network
    class Update < Dry::Struct
      COIN_REWARD = 50
      transform_keys(&:to_sym)

      attribute :id, Types::String.optional.default { '' }
      attribute :transactions, Types::Strict::Array.of(Transaction).default { [] }
      attribute :sender, Types::PublicKey
      attribute :signature, Types::String
    end
  end
end
