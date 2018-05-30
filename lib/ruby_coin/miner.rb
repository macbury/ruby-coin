# frozen_string_literal: true

module RubyCoin
  class Miner
    # How difficult is proof of concept
    INITIAL_DIFFICULTY = 4
    attr_reader :hasher, :difficulty, :difficulty_prefix

    def initialize(hasher:)
      @hasher = hasher
    end

    def adjust_difficulty(index)
      @difficulty_prefix = '0' * INITIAL_DIFFICULTY
    end

    def calculate(data:, prev_hash:, time:, index:)
      adjust_difficulty(index)
      nonce = 1
      @hasher.with(
        time: time,
        data: data,
        prev_hash: prev_hash,
        index: index
      )
      loop do
        hash = @hasher.calculate(nonce: nonce)

        return [hash, nonce] if hash.start_with?(difficulty_prefix)
        nonce += 1
      end
    end
  end
end
