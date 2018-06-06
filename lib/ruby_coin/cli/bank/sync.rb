# frozen_string_literal: true

module RubyCoin
  module Cli
    module Bank
      class Sync < Base
        desc 'Sync state of transactions'
        def call(*)
          chain.each_confirmed_from_index(bank.current_sync_index) do |block|
            puts "Syncing block: #{block.index}"
            bank << block
          end
        end
      end
    end
  end
end
