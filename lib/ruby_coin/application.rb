# frozen_string_literal: true

module RubyCoin
  class Application
    extend Dry::Initializer
    option :database_url, default: -> { 'sqlite://data/blockchain.db' }

    attr_reader :database

    def initialize(*)
      super
      Sequel.default_timezone = :utc
      @database = Sequel.connect(database_url)
    end

    def chain
      @chain ||= Chain.new(database: database)
    end

    def current_account
      @current_account ||= Social::PrivateAccount.generate
    end
  end
end
