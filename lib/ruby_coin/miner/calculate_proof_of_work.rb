# frozen_string_literal: true

require 'socket'

module RubyCoin
  module Miner
    class CalculateProofOfWork < Worker
      extend Dry::Initializer

      PREPARE_HASHING = 'PREPARE_HASHING'
      CALCULATE = 'CALCULATE'

      def prepare(data:, prev_hash:, time:, index:)
        perform_async(
          type: PREPARE_HASHING,
          data: data,
          prev_hash: prev_hash,
          time: time,
          index: index
        )

        wait_for_response
      end

      def calculate(nonce)
        perform_async(type: CALCULATE, nonce: nonce)
      end

      private

      def hasher
        @hasher ||= Crypto::Hasher.new
      end

      def handle_request(instruction)
        type = instruction['type']
        case instruction['type']
          when PREPARE_HASHING then return prepare_hashing(instruction)
          when CALCULATE then return run_calculate(instruction)
          else throw "Could not handle instruction: #{instruction}"
        end
        true
      end

      def prepare_hashing(options)
        @difficulty_prefix = '0' * Block.difficulty_for(options['index'])
        hasher.prepare(
          data: options['data'],
          prev_hash: options['prev_hash'],
          time: options['time'],
          index: options['index']
        )
        { success: true }
      end

      def run_calculate(options)
        nonce = options['nonce']
        hash = hasher.calculate(nonce: nonce)
        { hash: hash, nonce: nonce, success: true } if hash.start_with?(@difficulty_prefix)
      end
    end
  end
end
