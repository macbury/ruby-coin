# frozen_string_literal: true

module RubyCoin
  module Validation
    extend ActiveSupport::Autoload

    autoload :Block
    autoload :Chain
    autoload :Action
    autoload :Errors
  end
end
