# frozen_string_literal: true

module RubyCoin
  module Cli
    module Account
      extend ActiveSupport::Autoload

      autoload :CreateAccount
      autoload :ListAccount
    end
  end
end
