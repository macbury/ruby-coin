# frozen_string_literal: true

module RubyCoin
  module Miner
    class Master
      include Enumerable
      extend Dry::Initializer
      option :chain

      MAX_NONCE = 2**32 - 1

      # Generate genesis block
      # @return [Block]
      def genesis_block
        find_next_block([], Block::GENESIS_BLOCK_HASH)
      end

      # Add data to chain, and compute its values
      # @param updates [Array<Social::Update>] updates added to blockchain
      # @return [Block] created block
      def mine(updates)
        find_next_block(updates, chain.last.hash)
      end

      alias_method :<<, :mine

      private

      def find_next_block(updates, prev_hash)
        time = Time.now.utc
        #transactions_hash = transactions.map(&:id).join
        index = chain.max_index + 1
        hash, nonce = calculate_proof_of_work(data: 'transactions_hash', prev_hash: prev_hash, time: time, index: index)

        Block.new(
          hash: hash,
          nonce: nonce,
          time: time,
          prev_hash: prev_hash,
          index: index,
          updates: updates
        )
      end

      def hasher
        @hasher ||= Crypto::Hasher.new
      end

      def calculate_proof_of_work(data:, prev_hash:, time:, index:)
        nonce = 1
        difficulty_prefix = '0' * Block.difficulty_for(index)
        hasher.prepare(
          prev_hash: prev_hash,
          time: time,
          index: index,
          data: data
        )

        while nonce < MAX_NONCE
          hash = hasher.calculate(nonce: nonce)
          return [hash, nonce] if hash.start_with?(difficulty_prefix)
          nonce += 1
        end
      end
    end
  end
end
