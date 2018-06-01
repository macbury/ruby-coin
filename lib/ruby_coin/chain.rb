# frozen_string_literal: true

module RubyCoin
  class Chain
    include Enumerable
    extend Dry::Initializer
    option :database_url, default: -> { 'sqlite://data/blockchain.db' }

    def initialize(options)
      super
      Sequel.default_timezone = :utc
      @db = Sequel.connect(database_url)
      create_tables
    end

    def clear
      blocks.truncate
    end

    def each
      blocks.order(:index).paged_each do |record|
        yield build_block(record)
      end
    end

    def <<(block)
      record = block.to_h
      record[:transactions] = record[:transactions].to_json
      blocks.insert(record)
    end

    def last
      build_block(blocks.order(:index).last)
    end

    def find_by_index(index)

    end

    def find_by_hash(hash)

    end

    def size
      blocks.count
    end

    def empty?
      size == 0
    end

    # Get current max block index in chain
    # @return [Integer]
    def max_index
      blocks.max(:index) || 0
    end

    private

    def build_block(record)
      record[:transactions] = JSON.parse(record[:transactions]).symbolize_keys
      RubyCoin::Block.new(record)
    end

    def create_tables
      @db.create_table? :blocks do
        primary_key :index
        String :hash, uniq: true, null: false
        String :prev_hash, null: false
        Integer :nonce, null: false
        Time :time, null: false
        String :transactions, null: false
      end
    end

    def blocks
      @blocks ||= @db[:blocks]
    end
  end
end
