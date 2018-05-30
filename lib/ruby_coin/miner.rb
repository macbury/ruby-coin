# frozen_string_literal: true

module RubyCoin
  class Miner
    attr_reader :hasher, :difficulty, :difficulty_prefix

    def initialize(difficulty: Block::DIFFICULTY, hasher:)
      @difficulty = difficulty
      @difficulty_prefix = '0' * difficulty
      @hasher = hasher
    end

    def calculate(data:, prev_hash:, time:, index:)
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
