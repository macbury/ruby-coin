# frozen_string_literal: true

module RubyCoin
  module Ledger
    class Wallet
      extend Dry::Initializer

      option :public_key
      option :private_key

      # Generate new wallet with public and private key pair using ECDSA - prime256v1 curve
      # @return [Wallet] a new wallet
      def self.generate
        key = OpenSSL::PKey::EC.new('prime256v1')
        key.generate_key
        public_key = key.public_key.to_bn.to_s(16).downcase
        private_key = key.private_key.to_s(16).downcase
        new(public_key: public_key, private_key: private_key)
      end
    end
  end
end
