# frozen_string_literal: true

module RubyCoin
  module Crypto
    module Merkle
      class Node < Dry::Struct
        transform_keys(&:to_sym)

        attribute :hash, Types::Hash
        attribute :left, Node.optional.default { nil }
        attribute :right, Node.optional.default { nil }

        def hash
          attributes[:hash]
        end
      end
    end
  end
end
