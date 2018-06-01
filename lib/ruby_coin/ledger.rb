# frozen_string_literal: true

module RubyCoin
  module Ledger
    extend ActiveSupport::Autoload

    autoload :Wallet
    autoload :TxInput
    autoload :TxOutput
    autoload :Transaction
  end
end
