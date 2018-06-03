# frozen_string_literal: true

module RubyCoin
  module Social
    class PrivateAccount < PublicAccount
      attribute :private_key, Types::PrivateKey

      # Generate new account with public and private key pair using ECDSA - prime256v1 curve
      # @return [Wallet] a new wallet
      def self.generate
        new(Crypto::Keys.generate)
      end

      # Key that can be used to sign data
      # @return [OpenSSL::PKey::EC]
      def key
        @key ||= Crypto::Keys.build_key(public_key, private_key)
      end

      # Sign data with account key
      # @return [String] signature of data
      def sign(data)
        key.dsa_sign_asn1(data)
      end
    end
  end
end
