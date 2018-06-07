# frozen_string_literal: true

module RubyCoin
  module Social
    class Action < Dry::Struct
      transform_keys(&:to_sym)

      attribute :id, Types::String
      attribute :time, Types::Params::Time
      attribute :action, Types::Action
      attribute :hash, Types::Hash

      def hash
        attributes[:hash]
      end

      # Check if hash of data is valid
      # @return [Boolean]
      def valid_hash?
        Digest::SHA256.hexdigest(ordered_data([:hash, :signature])) == hash
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

      private

      def ordered_data(except_keys = [])
        attributes.except(*except_keys).keys.sort.map { |key| attributes[key] }.join
      end
    end
  end
end
