# frozen_string_literal: true

require 'dry/events/publisher'
module RubyCoin
  class Application
    extend Dry::Initializer
    include Dry::Events::Publisher[:my_publisher]

    register_event('transaction.new')

    option :database_url, default: -> { 'sqlite://data/blockchain.db' }

    attr_reader :database

    def initialize(*)
      super
      Sequel.default_timezone = :utc
      @database = Sequel.connect(database_url)
      #@database.logger = logger
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def pending_actions
      @pending_actions ||= Social::PendingActions.new(chain: chain)
    end

    def chain
      @chain ||= Chain.new(database: database)
    end

    def roster
      @roster ||= Node::Roster.new
    end

    def wallet
      @wallet ||= Wallet.new(database: database)
    end

    def bank
      @bank ||= Bank.new(database: database)
    end

    def current_account
      @current_account ||= Social::PrivateAccount.generate
    end

    def client
      @client ||= Node::Client.new('localhost:7000')
    end

    def self.current
      @current ||= RubyCoin::Application.new
    end
  end
end
