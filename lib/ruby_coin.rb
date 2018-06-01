# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'digest'
require 'json'
require 'openssl'
Bundler.require(:default, :development)
require 'active_support'
require 'active_support/hash_with_indifferent_access'

module RubyCoin
  extend ActiveSupport::Autoload

  autoload :Crypto
  autoload :Types
  autoload :Block
  autoload :Chain
  autoload :Miner
  autoload :Schema
  autoload :Validation

  autoload :Ledger
end
