# frozen_string_literal: true

module RubyCoin
  class Chain
    include Enumerable
    extend Dry::Initializer
    option :database

    def clear
      blocks.truncate
    end

    def each
      blocks.order(:index).paged_each do |record|
        yield build_block(record)
      end
    end

    def each_confirmed_from_index(index)
      blocks.where(Sequel[:index] <= confirmed_index).where(Sequel[:index] > index).order(:index).paged_each do |record|
        yield build_block(record)
      end
    end

    def <<(block)
      record = block.to_h.except(:updates)
      record[:actions] = record[:actions].to_json
      blocks.insert(record)
    end

    def last
      block = blocks.order(:index).last
      build_block(block) if block
    end

    def find_by_index(index)
      record = blocks.where(index: index).first
      build_block(record) if record
    end

    def find_by_hash(hash)
      record = blocks.where(hash: hash).first
      build_block(record) if record
    end

    def [](hash_or_index)
      find_by_hash(hash_or_index) || find_by_index(hash_or_index)
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

    # Next block index
    # @return [Integer]
    def next_index
      max_index + 1
    end

    # To which index, blocks actions are confirmed
    # @return [Integer]
    def confirmed_index
      max_index - Block::CONFIRMATION_COUNT
    end

    private

    def build_block(record)
      record[:actions] = JSON.parse(record[:actions])
      Block.new(record)
    end

    def create_tables
      database.create_table? :blocks do
        primary_key :index
        String :hash, uniq: true, null: false
        String :prev_hash, null: false
        String :actions, null: false
        Integer :nonce, null: false
        Time :time, null: false
        String
      end
    end

    def blocks
      @blocks ||= begin
        create_tables
        database[:blocks]
      end
    end
  end
end
