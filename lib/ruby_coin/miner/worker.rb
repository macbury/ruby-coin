# frozen_string_literal: true

require 'socket'

module RubyCoin
  module Miner
    # Simple worker base used for background processing stuff
    class Worker
      MAXLEN = 80_000

      def perform_async(options)
        start unless alive?
        @parent_socket.send(options.to_json, 0)
      end

      def start
        return if alive?
        @child_socket, @parent_socket = Socket.pair(:UNIX, :DGRAM, 0)
        @pid = fork do
          @parent_socket.close

          begin
            loop do
              instruction = JSON.parse(@child_socket.recv(MAXLEN))
              response = perform(instruction)
              @child_socket.send({ response: response }.to_json, 0) if response
            end
          rescue Interrupt
            nil
          end
        end
      end

      def alive?
        pid && Process.waitpid(pid, Process::WNOHANG)
      end

      def stop
        Process.kill(0, pid) if alive?
        @pid = nil
      end

      def perform(_instruction)
        raise 'Implement this logic...'
      end

      private

      attr_reader :maxlen, :child_socket, :parent_socket, :pid
    end
  end
end
