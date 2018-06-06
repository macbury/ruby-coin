# frozen_string_literal: true

module RubyCoin
  module Cli
    module Bank
      extend ActiveSupport::Autoload
      autoload :Sync
      autoload :Transfer
    end
  end
end
