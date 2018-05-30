# frozen_string_literal: true

module RubyCoin
  class Hasher
    # something, something use CUDA here
    def calculate(nonce:, time:, prev_hash:, data:, index:)
      Digest::SHA256.hexdigest("#{index}/#{nonce}/#{time.to_i}/#{prev_hash}/#{data.to_json}")
    end
  end
end
