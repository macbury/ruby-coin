# frozen_string_literal: true

module RubyCoin
  module Social
    class ActionBuilder
      def use_account(private_account)
        @private_account = private_account
      end

      def coinbase(recipient)
        Coinbase.new(build(recipient: recipient, amount: 3, action: 'coinbase'))
      end

      def transaction(recipient, amount)
        Transaction.new(build(
          amount: amount,
          recipient: recipient,
          action: 'transaction'
        ))
      end

      private

      attr_reader :private_account

      def build(data)
        @data = data.clone.deep_symbolize_keys
        @data[:id] ||= SecureRandom.hex(3)
        @data[:sender] = private_account.public_key if private_account
        @data[:hash] = Digest::SHA256.hexdigest(ordered_values(@data))
        @data[:signature] = private_account.sign(ordered_values(data.except(:sender))) if private_account
        @data
      end

      def ordered_values(data)
        data.keys.sort.map { |key| data[key] }.join
      end
    end
  end
end
