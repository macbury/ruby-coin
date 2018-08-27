# frozen_string_literal: true

module RubyCoin
  module Crypto
    module Merkle
      class Tree
        attr_reader :hashes, :root, :leaves

        # @param hashes [Array<String>]
        def initialize(hashes)
          @hashes = hashes
          @leaves = []
          @root = build
        end

        private

        def build
          level = @leaves = @hashes.map { |hash| Node.new(hash: hash) }
          return @leaves[0] if @leaves.size == 1

          while level.size > 1
            level = level.each_slice(2).map do |left, right|
              hash = Digest::SHA256.hexdigest([left, right].compact.map(&:hash).join)
              Node.new(hash: hash, left: left, right: right)
            end
          end

          level[0]
        end
      end
    end
  end
end
