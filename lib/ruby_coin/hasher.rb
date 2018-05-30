# frozen_string_literal: true

module RubyCoin
  class Hasher

    def valid?(block)
      with(block.to_h.except(:hash, :nonce))
      hash = calculate(nonce: block.nonce)
      block.hash == hash
    end

    def with(time:, prev_hash:, data:, index:)
      @time = time.to_i
      @prev_hash = prev_hash
      @data = data.to_json
      @index = index
    end

    # something, something use CUDA here
    def calculate(nonce:)
      Digest::SHA256.hexdigest("#{@index}/#{nonce}/#{@time}/#{@prev_hash}/#{@data}")
    end
  end
end
