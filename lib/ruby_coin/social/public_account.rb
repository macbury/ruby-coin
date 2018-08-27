# frozen_string_literal: true

module RubyCoin
  module Social
    class PublicAccount < Dry::Struct
      transform_keys(&:to_sym)

      attribute :public_key, Types::PublicKey

      # Check if data was created by this account
      # @param signature [String] signature for data
      # @param data [String] data to verify
      # @return [Boolean]
      def verify(signature, data)
        Crypto::Keys.verify([signature].pack('H*'), public_key, data)
      end

      # Address of this account. Unique for whole network
      # @return [String]
      def address
        @address ||= Crypto::Keys.address(public_key)
      end
    end
  end
end
