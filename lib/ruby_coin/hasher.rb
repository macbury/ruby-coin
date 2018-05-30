# frozen_string_literal: true

module RubyCoin
  class Hasher
    def initialize
      @digest = OpenSSL::Digest::SHA512.new
    end

    def valid?(block)
      return false unless block.hash.start_with?('0' * Miner::INITIAL_DIFFICULTY)
      with(block.to_h.except(:hash, :nonce))
      hash = calculate(nonce: block.nonce)
      block.hash == hash
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
