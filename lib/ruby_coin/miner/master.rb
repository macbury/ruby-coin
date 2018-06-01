# frozen_string_literal: true

module RubyCoin
  module Miner
    class Master
      include Enumerable
      extend Dry::Initializer
      option :chain

      MAX_NONCE = 2**32 - 1

      def initialize(*)
        super
        @workers = Workers.new
      end

      # Add data to chain, and compute its values
      # @param data [Hash] data added to blockchain
      # @return [Block] created block
      def <<(data)
        return find_next_block(data, Block::GENESIS_BLOCK_HASH) if chain.empty?
        find_next_block(data, chain.last.hash)
      end

      alias_method :mine, :<<

      private

      attr_reader :workers

      def hasher
        @hasher ||= Crypto::Hasher.new
      end

      def calculate_proof_of_work(data:, prev_hash:, time:, index:)
        nonce = 1
        difficulty_prefix = '0' * Block.difficulty_for(index)
        hasher.prepare(
          data: data,
          prev_hash: prev_hash,
          time: time,
          index: index
        )

        while nonce < MAX_NONCE
          hash = hasher.calculate(nonce: nonce)
          return [hash, nonce] if hash.start_with?(difficulty_prefix)
          nonce += 1
        end
      end

      def find_next_block(data, prev_hash)
        time = Time.now.utc
        index = chain.max_index + 1
        hash, nonce = calculate_proof_of_work(data: data, prev_hash: prev_hash, time: time, index: index)

        Block.new(
          hash: hash,
          nonce: nonce,
          time: time,
          data: data,
          prev_hash: prev_hash,
          index: index
        )
      end
    end
  end
end
