# frozen_string_literal: true

module RubyCoin
  module Miner
    class Workers
      extend Dry::Initializer
      def initialize
        @workers = Array.new(4) { CalculateProofOfWork.new }
        @on_complete = Proc.new {}
        @on_ready = Proc.new {}

        @workers.each(&:start)
      end

      def on_ready(&block)
        @on_ready = block
      end

      def on_complete(&block)
        @on_complete = block
      end

      def prepare(data:, prev_hash:, time:, index:)
        @workers.each do |worker|
          worker.prepare(
            data: data,
            prev_hash: prev_hash,
            time: time,
            index: index,
          )
        end
      end

      def start
        @running = true
        @workers.each do |worker|
          @on_ready.call(worker)
        end

        while @running
          @workers.each do |worker|
            response = worker.read_response
            if response
              action = @on_complete.call(response)
              return if action == :stop
              @on_ready.call(worker)
            end
          end
        end
      ensure
        stop
      end

      def stop
        @running = false
      end

    end
  end
end
