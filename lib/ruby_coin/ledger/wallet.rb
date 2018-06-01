# frozen_string_literal: true

module RubyCoin
  module Ledger
    class Wallet < Dry::Struct
      transform_keys(&:to_sym)

      attribute :private_key, Types::PrivateKey
      attribute :public_key, Types::PublicKey

      # Generate new wallet with public and private key pair using ECDSA - prime256v1 curve
      # @return [Wallet] a new wallet
      def self.generate
        new(Crypto::Keys.generate)
      end
    end
  end
end
