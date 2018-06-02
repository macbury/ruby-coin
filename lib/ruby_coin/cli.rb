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

    register 'validate', Validate
    register 'mine', Mine
    register 'print', Print
    register 'genesis', Genesis
  end
end
