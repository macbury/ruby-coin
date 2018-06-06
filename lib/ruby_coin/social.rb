# frozen_string_literal: true

module RubyCoin
  module Social
    extend ActiveSupport::Autoload

    autoload :ActionBuilder
    autoload :UpdateBuilder
    autoload :Action
    autoload :PublicAccount
    autoload :PrivateAccount
    autoload :Transaction
    autoload :Coinbase
    autoload :Errors
  end
end
