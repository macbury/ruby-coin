# frozen_string_literal: true

module RubyCoin
  class Block < Dry::Struct
    transform_keys(&:to_sym)
    # Number of block from this block to be confirmed
    CONFIRMATION_COUNT = 10
    # Hash of genesis block
    GENESIS_BLOCK_HASH = ('0' * 64).freeze
    # @!attribute [r] index
    # @return [Integer] block index
    attribute :index, Types::Index
    # @!attribute [r] hash
    # @return [String] hash or id of current block based on its content
    attribute :hash, Types::BlockId
    # @!attribute [r] nonce
    # @return [Integer] winning number used to calculate proof of work
    attribute :nonce, Types::Nonce
    # @!attribute [r] time
    # @return [Time] time of finding proof of work
    attribute :time, Types::Params::Time
    # @!attribute [r] prev_hash
    # @return [String] hash to previosus block in chain
    attribute :prev_hash, Types::BlockId
    # @!attribute [r] actions
    # @return [Social::Actions] list of actions performed in network
    attribute :actions, Types::Actions

    def hash
      attributes[:hash]
    end

    # Returns merkle tree of block actions
    # @return [Crypto::Merkle::Tree]
    def merkle_tree
      @merkle_tree ||= Crypto::Merkle::Tree.new(actions.map(&:hash))
    end

    # Check if this block is valid, and appears after prev block
    # @param prev_block [Block] previosus block
    # @return [Boolean] true if is valid
    def after?(prev_block)
      (index - prev_block.index) == 1 && prev_block.time <= time && prev_block.hash == prev_hash
    end

    # Calculate difficulty for block index
    # @param index [Integer] block index
    # @return [Integer] difficlulty for PoW
    def self.difficulty_for(index)
      5 #TODO: add some logic here
    end
  end
end
