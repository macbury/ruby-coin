# frozen_string_literal: true

module RubyCoin
  class Miner
    attr_reader :hasher, :difficulty, :difficulty_prefix

    def initialize(difficulty: Block::DIFFICULTY)
      @difficulty = difficulty
      @difficulty_prefix = '0' * difficulty
      @hasher = Hasher.new
    end

    def calculate(data:, prev_hash:, time:)
      nonce = 0
      loop do
        hash = @hasher.calculate(
          nonce: nonce,
          time: time,
          serialized_data: data.to_bson,
          prev_hash: prev_hash,
          difficulty: difficulty
        )

        return [hash, nonce] if hash.start_with?(difficulty_prefix)
        nonce += 1
      end
    end
  end
end
