# frozen_string_literal: true

module RubyCoin
  module Ledger
    class TxInput < Dry::Struct
      transform_keys(&:to_sym)

      attribute :vout, Types::Integer
      attribute :script_sig, Types::String
    end
  end
end
