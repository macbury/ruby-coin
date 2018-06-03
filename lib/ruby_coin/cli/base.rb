# frozen_string_literal: true
module RubyCoin
  module Cli
    class Base < Hanami::CLI::Command
      def application
        @application ||= Application.new
      end

      def chain
        application.chain
      end
    end
  end
end
