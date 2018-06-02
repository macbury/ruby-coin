# frozen_string_literal: true

module RubyCoin
  module Social
    extend ActiveSupport::Autoload

    autoload :PublicAccount, './social/account'
    autoload :PrivateAccount, './social/account'
    autoload :Transaction
    autoload :Update
  end
end
