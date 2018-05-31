# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'digest'
require 'json'
Bundler.require(:default, :development)
require 'active_support'
require 'active_support/hash_with_indifferent_access'

module RubyCoin
  extend ActiveSupport::Autoload

  autoload :Types
  autoload :Block
  autoload :Blockchain
  autoload :Chain
  autoload :Hasher
  autoload :Miner
  autoload :Schema
  autoload :Validation
end
