# frozen_string_literal: true

module RubyCoin
  module Miner
    class Master
      include Enumerable
      extend Dry::Initializer
      option :chain

      def initialize(*)
        super

        @workers = Array.new(4) { CalculateProofOfWork.new }
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

      def calculate_proof_of_work(data:, prev_hash:, time:, index:)
        workers.first.perform_async(
          data: data,
          prev_hash: prev_hash,
          time: time,
          index: index,
          ranges: (0..1000)
        )
      end

      def find_next_block(data, prev_hash)
        time = Time.now.utc
        index = chain.max_index + 1
        hash, nonce = calculate_proof_of_work(data: data, prev_hash: prev_hash, time: time, index: index)

        build_block(hash: hash, nonce: nonce) if hash
      end

      def build_block(hash:, nonce:)
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
