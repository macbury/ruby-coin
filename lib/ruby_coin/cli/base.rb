# frozen_string_literal: true
module RubyCoin
  module Cli
    class Base < Hanami::CLI::Command
      def application
        @application ||= Application.current
      end

      def chain
        application.chain
      end

      def bank
        application.bank
      end

      def wallet
        application.wallet
      end
    end
  end
end
