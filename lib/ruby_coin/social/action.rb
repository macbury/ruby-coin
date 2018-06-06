# frozen_string_literal: true

module RubyCoin
  module Social
    class Action < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Types::String
      attribute :action, Types::Action
      attribute :hash, Types::Hash

      def hash
        attributes[:hash]
      end

      def self.build(options)
        options.deep_symbolize_keys!
        action = options[:action]
        if action == 'transaction'
          Transaction.new(options)
        elsif action == 'coinbase'
          Coinbase.new(options)
        else
          raise Errors::NotSupportedAction, "Unsuported action: #{options.inspect}"
        end
      end
    end
  end
end
