# frozen_string_literal: true

module RubyCoin
  class Blockchain
    attr_reader :storage, :miner

    def initialize(storage = [])
      @storage = storage
      @miner = Miner.new
    end

    # Add without verification, block to chain
    def <<(block)
      @storage << block
    end

    # Generate genesis block
    # @param data [Hash] transaction data, added to chain
    # @return [Block] first block in chain
    def first(data)
      throw 'Blockchain is not empty....' unless @storage.empty?
      push(data, Block::GENESIS_BLOCK_HASH)
    end

    # Generate next block in chain
    # @param data [Hash] transaction data
    def next(data, prev = nil)
      prev_hash = (prev || @storage[-1]).hash
      push(data, prev_hash)
    end

    def broken?
      storage.each_with_index do |block, index|
        next if index.zero? && block.after?(Block::GENESIS_BLOCK_HASH)
        next if block.after?(storage[index - 1].hash)
        return true
      end
      false
    end

    private

    def push(data, prev_hash)
      time = Time.now
      hash, nonce = miner.calculate(data: data, prev_hash: prev_hash, time: time)
      block = Block.new(
        hash: hash,
        nonce: nonce,
        time: time,
        data: data,
        prev_hash: prev_hash
      )
      @storage << block
      block
    end
  end
end
