# frozen_string_literal: true
module RubyCoin
  module Cli
    class Reset < Base
      desc 'clear blockchain'
      def call(*)
        chain.clear
      end
    end
  end
end
