# frozen_string_literal: true

module RubyCoin
  module Crypto
    module Merkle
      extend ActiveSupport::Autoload

      autoload :Node
      autoload :Tree
    end
  end
end
