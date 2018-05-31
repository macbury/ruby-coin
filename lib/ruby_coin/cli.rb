# frozen_string_literal: true
require 'hanami/cli'
require 'terminal-table'

module RubyCoin
  module Cli
    extend ActiveSupport::Autoload
    extend Hanami::CLI::Registry

    autoload :Validate
    autoload :Mine
    autoload :Print
    autoload :Reset

    register 'validate', Validate
    register 'mine', Mine
    register 'print', Print
    register 'reset', Reset
  end
end
