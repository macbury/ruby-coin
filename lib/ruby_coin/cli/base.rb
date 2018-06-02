# frozen_string_literal: true
module RubyCoin
  module Cli
    class Base < Hanami::CLI::Command
      def application
        @application ||= Application.new
      end
    end
  end
end
