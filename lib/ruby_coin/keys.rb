module RubyCoin
  # Elliptic Curve Digital Signature
  module Keys
    ALGORITHM = 'prime256v1'
    # Generate public-private key pair using ECDSA - prime256v1 curve
    # @return [Hash] return keys
    def self.generate
      key = OpenSSL::PKey::EC.new(ALGORITHM)
      key.generate_key
      {
        private_key: format(key.private_key),
        public_key: format(key.public_key.to_bn)
      }
    end

    # Transform key to more human type format
    # @param key [OpenSSL::PKey::EC::Point] public or private key
    # @return [String] key in hex format
    def self.format(key)
      key.to_bn.to_s(16).upcase
    end

    # Rebuild the from hexa-bignum public key and private key
    # @param public_key [String]
    # @param private_key [String]
    # @return [OpenSSL::PKey::EC]
    def self.build_key(public_key, private_key)
      group = OpenSSL::PKey::EC::Group.new(ALGORITHM)
      key = OpenSSL::PKey::EC.new(group)

      public_bn = OpenSSL::BN.new(public_key, 16)
      private_bn = OpenSSL::BN.new(private_key, 16)
      public_key = OpenSSL::PKey::EC::Point.new(group, public_bn)

      key.public_key = public_key
      key.private_key = private_bn

      key
    end

    # Verify the signature
    # @param signature [String]
    # @param public_key [String]
    # @param data [String]
    # @return [Boolean] true if have valid signature
    def self.verify(signature, public_key, data)
      group = OpenSSL::PKey::EC::Group.new(ALGORITHM)
      key = OpenSSL::PKey::EC.new(group)
      public_bn = OpenSSL::BN.new(public_key, 16)
      public_key = OpenSSL::PKey::EC::Point.new(group, public_bn)
      key.public_key = public_key

      begin
        key.dsa_verify_asn1(data, signature)
      rescue OpenSSL::PKey::ECError
        false
      end
    end
  end
end
