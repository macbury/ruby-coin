# frozen_string_literal: true

module RubyCoin
  class Blockchain
    include Enumerable
    extend Dry::Initializer
    option :chain, default: -> { Chain.new }
    option :hasher, default: -> { Hasher.new }

    def each
      chain.each { |block| yield block }
    end

    # Add data to chain, and compute its values
    # @param data [Hash] data added to blockchain
    # @return [Block] created block
    def <<(data)
      if data.class >= Block
        chain << data # check if valid by computing hash of attributes
      elsif chain.empty?
        mine(data, Block::GENESIS_BLOCK_HASH)
      else
        mine(data, chain.last.hash)
      end
    end

    def broken?
      prev_block = nil
      chain.each do |block|
        if (prev_block.nil? || block.after?(prev_block)) && validation.valid?(block)
          prev_block = block
          next
        end
        return true
      end
      false
    end

    def valid?
      !broken?
    end

    def miner
      @miner ||= Miner.new(hasher: hasher)
    end

    def validation
      @validation ||= Validation.new(hasher: hasher)
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
      chain << block
      block
    end
  end
end
