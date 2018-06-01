# frozen_string_literal: true

module RubyCoin
  class Block < Dry::Struct
    transform_keys(&:to_sym)

    # Hash of genesis block
    GENESIS_BLOCK_HASH = ('0' * 64).freeze
    # @!attribute [r] index
    # @return [Integer] block index
    attribute :index, Types::Index
    # @!attribute [r] hash
    # @return [String] hash or id of current block based on its content
    attribute :hash, Types::BlockId
    # @!attribute [r] transactions
    # @return [Array<Transaction>] list of transactions
    attribute :transactions, Types::Strict::Array.of(Ledger::Transaction)
    # @!attribute [r] nonce
    # @return [Integer] winning number used to calculate proof of work
    attribute :nonce, Types::Nonce
    # @!attribute [r] time
    # @return [Time] time of finding proof of work
    attribute :time, Types::Strict::Time
    # @!attribute [r] prev_hash
    # @return [String] hash to previosus block in chain
    attribute :prev_hash, Types::BlockId

    def hash
      attributes[:hash]
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
      3 #TODO: add some logic here
    end
  end
end
