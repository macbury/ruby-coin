# frozen_string_literal: true

module RubyCoin
  class Block
    # How difficult is proof of concept
    DIFFICULTY = 4
    # Hash of genesis block
    GENESIS_BLOCK_HASH = '0'*64
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

    # Initialize genesis block
    # @param [Hash] simple hash
    # @return [Block] new block
    def self.first(data)
      new(data: data, prev_hash: GENESIS_BLOCK_HASH)
    end

    # Create next block from prev block
    # @param [Hash] simple hash
    # @param [Block] prev block
    # @return [Block] next block in chain
    def self.next(prev, data)
      new(data: data, prev_hash: prev.hash)
    end

    def initialize(data:, prev_hash:, nonce: nil, time: nil, difficulty: DIFFICULTY)
      @data = data
      @difficulty = difficulty
      @prev_hash = prev_hash

      if nonce && time
        @time = time
        @nonce = nonce
        @hash = calculate
      else
        calculate_proof_of_work
      end
    end

    # Create next block from current block
    # @param data [Hash] data simple hash
    # @return [Block] next block in chain
    def next(data)
      self.class.new(data: data, prev_hash: hash)
    end

    def valid?
      valid_proof_of_work?
    end

    # Check if this block is valid, and appears after prev block
    # @param prev_block_hash [String] previosus hash
    # @return [Boolean] true if is valid
    def after?(prev_block_hash)
      prev_block_hash == prev_hash && valid?
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

    private

    def calculate_proof_of_work
      @nonce = 0
      @time  = Time.now
      loop do
        @hash = calculate
        break if valid_proof_of_work?
        @nonce += 1
      end
    end

    def calculate
      Digest::SHA256.hexdigest("#{nonce}/#{time.to_i}/#{difficulty}/#{prev_hash}/#{serialized_data.to_s}")
    end

    def difficult_prefix
      @difficult_prefix ||= '0' * difficulty
    end

    def valid_proof_of_work?
      hash.start_with?(difficult_prefix)
    end
  end
end
