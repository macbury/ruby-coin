# frozen_string_literal: true

module RubyCoin
  module Miner
    class Master
      include Enumerable
      extend Dry::Initializer
      option :recipient
      option :chain

      MAX_NONCE = 2**32 - 1

      # Generate genesis block
      # @return [Block]
      def genesis_block
        find_next_block(actions: coinbase, prev_hash: Block::GENESIS_BLOCK_HASH)
      end

      # Add data to chain, and compute its values
      # @param updates [Array<Social::Update>] updates added to blockchain
      # @return [Block] created block
      def mine(actions)
        find_next_block(actions: coinbase + actions, prev_hash: chain.last.hash)
      end

      alias_method :<<, :mine

      private

      def coinbase
        [Social::ActionBuilder.new.coinbase(recipient)]
      end

      def hasher
        @hasher ||= Crypto::Hasher.new
      end

      def find_next_block(actions:, prev_hash:)
        time = Time.now.utc
        index = chain.next_index
        merkle_tree = Crypto::Merkle::Tree.new(actions.map { |action| action[:hash] })
        hash, nonce = calculate_proof_of_work(data: merkle_tree.root.hash, prev_hash: prev_hash, time: time, index: index)

        Block.new(
          hash: hash,
          nonce: nonce,
          time: time,
          prev_hash: prev_hash,
          index: index,
          actions: actions
        )
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
