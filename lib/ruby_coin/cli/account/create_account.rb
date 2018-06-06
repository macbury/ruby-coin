# frozen_string_literal: true

module RubyCoin
  module Cli
    module Account
      class CreateAccount < Base
        desc 'Create new account'
        def call(*)
          account = Social::PrivateAccount.generate
          application.wallet << account
          puts account.address
        end
      end
    end
  end
end
