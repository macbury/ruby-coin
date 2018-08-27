# frozen_string_literal: true

require 'hanami/cli'
require 'terminal-table'

module RubyCoin
  module Cli
    extend ActiveSupport::Autoload
    extend Hanami::CLI::Registry

    autoload :Base
    autoload :Validate
    autoload :Mine
    autoload :Print
    autoload :Reset
    autoload :Genesis
    autoload :Account
    autoload :Bank
    autoload :Node

    register 'node', Node
    register 'validate', Validate
    register 'mine', Mine
    register 'print', Print

    register 'account create', Account::CreateAccount
    register 'account list', Account::ListAccount

    register 'bank sync', Bank::Sync
    register 'bank transfer', Bank::Transfer
  end
end
