# frozen_string_literal: true

module RubyCoin
  module Node
    class Client
      include HTTParty
      raise_on [404, 500, 400]
      headers 'Content-Type' => 'application/json'

      def initialize(uri)
        @uri = HTTParty.normalize_base_uri(uri)
      end

      def ping?
        resp = self.class.get("#{@uri}/")
        Schema::Alive.call(resp).success?
      rescue HTTParty::ResponseError, Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL
        false
      end

      def block(block_index)
        resp = self.class.get("#{@uri}/blocks/#{block_index}")
        Block.new(resp) if resp.success?
      end

      def publish(action)
        self.class.post("#{@uri}/actions", body: action.to_h.to_json).success?
      end
    end
  end
end
