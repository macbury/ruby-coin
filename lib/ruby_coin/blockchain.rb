# frozen_string_literal: true

module RubyCoin
  class Blockchain
    include Enumerable

    attr_reader :chain, :miner, :hasher

    def initialize
      @chain = Chain.new
      @hasher = Hasher.new
      @miner = Miner.new(hasher: hasher)
    end

    # Search block by its index
    # @return [Block]
    def find_by_index(index)
      chain[index]
    end

    # Search block by its hash
    # @return [Block]
    def find_by_hash(hash)
      chain.find { |block| block.hash == hash }
    end

    def each
      chain.each { |block| yield block }
    end

    # Add data to chain, and compute its values
    # @param data [Hash] data added to blockchain
    # @return [Block] created block
    def <<(data)
      if data.class >= Block
        @chain << data # check if valid by computing hash of attributes
      elsif @chain.empty?
        mine(data, Block::GENESIS_BLOCK_HASH)
      else
        mine(data, chain.last.hash)
      end
    end

    def broken?
      prev_block = nil
      chain.each do |block|
        if (prev_block.nil? || block.after?(prev_block)) && block.hash == hasher.calculate(block.to_h.except(:hash))
          prev_block = block
          next
        end
        return true
      end
      false
    end

    private

    def mine(data, prev_hash)
      time = Time.now.utc
      index = chain.max_index + 1
      hash, nonce = miner.calculate(data: data, prev_hash: prev_hash, time: time, index: index)
      block = Block.new(
        hash: hash,
        nonce: nonce,
        time: time,
        data: data,
        prev_hash: prev_hash,
        index: index
      )
      @chain << block
      block
    end
  end
end
