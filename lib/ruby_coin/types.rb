# frozen_string_literal: true

module RubyCoin
  module Types
    include Dry::Types.module

    Index = Integer.constrained(gt: 0)
    Nonce = Integer.constrained(gt: 0)
    Difficulty = Integer.constrained(gt: 1)
    BlockId = String.constrained(format: /\A[a-z0-9]{64}\z/i)

    PublicKey = String.constrained(format: /\A[a-z0-9]{130}\z/i)
    PrivateKey = String.constrained(format: /\A[a-z0-9]{64}\z/i)
  end
end
