# frozen_string_literal: true

module RubyCoin
  module Social
    extend ActiveSupport::Autoload

    autoload :PublicAccount
    autoload :PrivateAccount
    autoload :Transaction
    autoload :Update
  end
end
