# frozen_string_literal: true

module RubyCoin
  module Cli
    module Account
      class ListAccount < Base
        desc 'List accounts with their balances'
        def call(*)
          Terminal::Table.new do |table|
            table << ['Address', 'Public Key']
            table.add_separator
            application.wallet.each do |private_account|
              table << [private_account.address, private_account.public_key]
            end
            puts table
          end
        end
      end
    end
  end
end
