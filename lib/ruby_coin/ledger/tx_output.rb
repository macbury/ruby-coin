# frozen_string_literal: true

module RubyCoin
  module Ledger
    class TxOutput < Dry::Struct
      transform_keys(&:to_sym)

      attribute :value, Types::Integer.constrained(gt: 0)
      attribute :to, Types::String
    end
  end
end
