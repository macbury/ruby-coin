# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'digest'
Bundler.require(:default, :development)
require 'active_support'

module RubyCoin
  extend ActiveSupport::Autoload

  autoload :Block
  autoload :Blockchain
  autoload :Hasher
  autoload :Miner
end
