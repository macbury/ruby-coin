# frozen_string_literal: true

module RubyCoin
  module Cli
    module Bank
      class Transfer < Base
        argument :sender, required: true, desc: 'Address that sends coins'
        argument :recipient, required: true, desc: 'Address that receives coins'
        argument :amount, required: true, desc: 'Amount coins to send'
        desc 'Transfer money from one account to another one'
        def call(sender:, recipient:, amount:)
          account = wallet.find { |account| account.address == sender }

          raise "Could not find account: #{sender}" unless account
          action_builder = Social::ActionBuilder.new
          action_builder.use_account(account)
          transaction = action_builder.transaction(recipient, amount.to_i)
          application.client.publish(transaction)
        end
      end
    end
  end
end
