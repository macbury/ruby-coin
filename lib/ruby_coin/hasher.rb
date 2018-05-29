# frozen_string_literal: true

module RubyCoin
  class Hasher
    # something, something use CUDA here
    def calculate(nonce:, time:, difficulty:, prev_hash:, serialized_data:)
      Digest::SHA256.hexdigest("#{nonce}/#{time.to_i}/#{difficulty}/#{prev_hash}/#{serialized_data.to_s}")
    end
  end
end
