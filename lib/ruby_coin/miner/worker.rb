# frozen_string_literal: true

require 'socket'

module RubyCoin
  module Miner
    # Simple worker base used for background processing stuff using unix socket for IPC
    class Worker
      MAXLEN = 80_000

      def perform_async(instruction)
        parent_socket.send(instruction.to_json, 0)
      end

      def can_read?
        parent_socket.ready?
      end

      def wait_for_boot
        loop do
          resp = JSON.parse(parent_socket.recv(MAXLEN))
          break if resp['boot']
        end
      end

      def wait_for_response
        loop do
          resp = JSON.parse(parent_socket.recv(MAXLEN))
          return resp['response'] if resp
        end
      end

      def read_response(block = false)
        JSON.parse(parent_socket.recv(MAXLEN)) if block || can_read?
      end

      def start
        return if alive?
        @child_socket, @parent_socket = Socket.pair(:UNIX, :DGRAM, 0)
        @pid = fork do
          @parent_socket.close

          begin
            @child_socket.send({ boot: true }.to_json, 0)
            loop do
              instruction = JSON.parse(@child_socket.recv(MAXLEN))
              response = handle_request(instruction)
              @child_socket.send({ response: response }.to_json, 0)
            end
          rescue Exception => e
            puts "[#{Process.pid}] #{e.to_s}"
            puts e.backtrace.join("\n")
          rescue Interrupt
            nil
          end
        end

        wait_for_boot
      end

      def alive?
        pid && Process.waitpid(pid, Process::WNOHANG)
      rescue Errno::ECHILD
        @pid = nil
      end

      def stop
        Process.kill(:KILL, pid) if alive?
        @pid = nil
      rescue Errno::ESRCH

      end

      private

      attr_reader :maxlen, :child_socket, :parent_socket, :pid

      def handle_request(_instruction)
        raise 'Implement this logic...'
      end
    end
  end
end
