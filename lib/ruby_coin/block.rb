# frozen_string_literal: true

module RubyCoin
  class Block
    # How difficult is proof of concept
    DIFFICULTY = 4
    # Hash of genesis block
    GENESIS_BLOCK_HASH = ('0'*64).freeze
    # @!attribute [r] version
    # @return [Hash] current block data
    attr_reader :data
    # @!attribute [r] nonce
    # @return [Integer] winning number used to calculate proof of work
    attr_reader :nonce
    # @!attribute [r] time
    # @return [Time] time of finding proof of work
    attr_reader :time
    # @!attribute [r] prev_hash
    # @return [String] hash to previosus block in chain
    attr_reader :prev_hash
    # @!attribute [r] difficult
    # @return [Integer] difficulty of calculating proof of work
    attr_reader :difficulty
    # @!attribute [r] hash
    # @return [String] hash or id of current block based on its content
    attr_reader :hash

    def initialize(data:, prev_hash:, nonce: nil, time: nil, difficulty: DIFFICULTY, hash:)
      @data = data
      @difficulty = difficulty
      @prev_hash = prev_hash
      @hash = hash
      @time = time
      @nonce = nonce
    end

    # Check if this block is valid, and appears after prev block
    # @param prev_block_hash [String] previosus hash
    # @return [Boolean] true if is valid
    def after?(prev_block_hash)
      prev_block_hash == prev_hash
    end

    # Return serialized data
    # @return [BSON::ByteBuffer] bsoned data
    def serialized_data
      data.to_bson
    end

    # Return hash representation of block
    # @return [Hash]
    def to_h
      {
        data: data,
        nonce: nonce,
        time: time,
        prev_hash: prev_hash
      }
    end

    # Serialized representation of block
    # @return [BSON::ByteBuffer] bsoned block
    def to_bson
      to_h.to_bson
    end
  end
end
