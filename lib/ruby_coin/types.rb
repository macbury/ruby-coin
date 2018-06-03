# frozen_string_literal: true

module RubyCoin
  module Types
    include Dry::Types.module

    Index = Integer.constrained(gt: 0)
    Nonce = Integer.constrained(gt: 0)
    Value = Integer.constrained(gt: 0)
    Difficulty = Integer.constrained(gt: 1)
    BlockId = String.constrained(format: /\A[a-z0-9]{64}\z/i)
    Hash = String.constrained(format: /\A[a-z0-9]{64}\z/i)

    PublicKey = String.constrained(format: /\A[a-z0-9]{130}\z/i)
    PrivateKey = String.constrained(format: /\A[a-z0-9]{64}\z/i)

    Address = String.constrained(format: /\A[a-z0-9\.]{33}\z/i)
    Username = String.constrained(format: /\A[a-z0-9\.]{32}\z/i)

    Action = Types::Strict::String.enum('transaction', 'coinbase')

    Actions = Types::Strict::Array.of(Social::Action).constructor do |actions|
      actions.map do |action|
        if action.is_a?(::Hash)
          action.deep_symbolize_keys!
          if action[:action] == 'coinbase'
            Social::Coinbase.new(action)
          else
            Social::Action.new(action)
          end
        else
          action
        end
      end
    end
  end
end
