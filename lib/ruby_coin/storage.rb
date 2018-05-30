# frozen_string_literal: true

module RubyCoin
  class Storage
    extend Dry::Initializer

    option :storage_path, default: proc { './data' }

    # Store blockchain on disk
    # @param blockchain [Blockchain] data to store
    # @return [NilClass]
    def store(blockchain)
      create_dir
      blockchain.each do |block|
        File.open(block_path(block), 'wb') do |file|
          buffer = block.to_bson
          while buffer.length > 0
            file.write buffer.get_byte
          end
        end
      end
      nil
    end

    def sync(blockchain)
      blockchain.clear
      Dir[File.join(storage_path, '*.block')].sort.each do |file_path|
        blockchain << RubyCoin::Block.from_bson(File.open(file_path, 'rb').read)
      end
    end

    private

    def create_dir
      FileUtils.mkdir_p(storage_path)
    end

    def block_path(block)
      File.join(storage_path, "#{block.index}.block")
    end
  end
end
