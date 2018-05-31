# frozen_string_literal: true

module RubyCoin
  class Hasher
    def initialize
      @digest = OpenSSL::Digest::SHA256.new
    end

    def with(time:, prev_hash:, data:, index:)
      @time = time.to_i.to_s
      @prev_hash = prev_hash
      @data = data.to_json
      @index = index.to_s
    end

    # something, something use CUDA here
    def calculate(nonce:)
      digest << @index
      digest << nonce.to_s
      digest << @time
      digest << @prev_hash
      digest << @data
      digest.hexdigest!
    end

    private

    attr_reader :digest
  end
end
