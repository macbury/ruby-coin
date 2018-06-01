# frozen_string_literal: true

module RubyCoin
  module Ledger
    class Transaction < Dry::Struct
      COIN_REWARD = 50
      transform_keys(&:to_sym)

      attribute :id, Types::String.optional.default { '' }
      attribute :inputs, Types::Strict::Array.of(TxInput)
      attribute :outputs, Types::Strict::Array.of(TxOutput)

      # Create coinbase transaction with reward for mining a block
      # @param to [String] reciepient address
      def self.new_coinbase(to)
        data = "Reward to #{to}"
        new(
          inputs: [
            TxInput.new(vout: -1, script_sig: data)
          ],
          outputs: [
            TxOutput.new(value: COIN_REWARD, to: to)
          ]
        )
      end


      def calculate_hash
        
      end
    end
  end
end
