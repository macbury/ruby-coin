# frozen_string_literal: true

module RubyCoin
  class Wallet
    include Enumerable
    extend Dry::Initializer
    option :database

    def each
      accounts.order(:public_key).paged_each do |record|
        yield build_account(record)
      end
    end

    # Add new account to wallet
    # @return [Social::PrivateAccount]
    def <<(private_account)
      accounts.insert(private_account.to_h)
    end

    private

    def build_account(record)
      Social::PrivateAccount.new(record)
    end

    def create_tables
      database.create_table? :wallets do
        primary_key :index
        String :private_key, null: false
        String :public_key, null: false
      end
    end

    def accounts
      @accounts ||= begin
        create_tables
        database[:wallets]
      end
    end
  end
end
