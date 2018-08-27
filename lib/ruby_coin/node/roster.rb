# frozen_string_literal: true

module RubyCoin
  module Node
    class Roster
      include Enumerable

      def initialize
        @nodes = []
      end

      def fetch
        @nodex = [
          'localhost:7000',
          'localhost:7001',
          'localhost:7002',
          'localhost:7003'
        ].map { |uri| Client.new(uri) }.select(&:ping?)
      end

      def each
        @nodex.each { |client| yield client }
      end
    end
  end
end
