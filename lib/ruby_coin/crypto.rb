# frozen_string_literal: true

module RubyCoin
  module Crypto
    extend ActiveSupport::Autoload

    autoload :Keys
    autoload :Hasher
    autoload :Merkle
  end
end
