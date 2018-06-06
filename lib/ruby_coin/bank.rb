# frozen_string_literal: true

module RubyCoin
  # This class contains all addresses with their balances
  class Bank
    include Enumerable
    extend Dry::Initializer
    option :database

    # Update balances for account
    # @param block [Block] block to index
    # @return [NilClass]
    def <<(block)
      block.actions.each do |action|
        if action.is_a?(Social::Coinbase)
          consume_coinbase(block, action)
        else
          throw 'Unsuported action'
        end
      end
      nil
    end

    def current_sync_index
      balances.max(:index) || 0
    end

    private

    def create_tables
      database.create_table? :balances do
        String :address, null: false, unique: true
        Integer :amount, default: 0
        Integer :index, default: 0
      end
    end

    def balances
      @balances ||= begin
        create_tables
        database[:balances]
      end
    end

    def find_or_initialize_balance(address)
      balances.where(address: address).first&.dig(:index) || balances.insert(address: address)
    end

    # Update account balance using coinbase
    # @param block [Block]
    # @param coinbase [Social::Coinbase]
    def consume_coinbase(block, coinbase)
      balance_id = find_or_initialize_balance(coinbase.recipient)
      balances.where(index: balance_id).update(amount: Sequel[:amount] + coinbase.amount, index: block.index)
    end
  end
end
