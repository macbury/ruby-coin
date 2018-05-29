# frozen_string_literal: true

module RubyCoin
  class Blockchain
    attr_reader :storage

    def initialize(storage = [])
      @storage = storage
    end

    # Add without verification, block to chain
    def <<(block)
      @storage << block
    end

    def first(data)
      throw 'Blockchain is not empty....' unless @storage.empty?
      block = Block.first(data)
      @storage << block
      block
    end

    def next(data, prev = nil)
      block = Block.new(data: data, prev_hash: (prev || @storage[-1]).hash)
      @storage << block
      block
    end

    def broken?
      storage.each_with_index do |block, index|
        next if index.zero? && block.after?(Block::GENESIS_BLOCK_HASH)
        next if block.after?(storage[index - 1].hash)
        return true
      end
      false
    end
  end
end
