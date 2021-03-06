# frozen_string_literal: true

module RubyCoin
  module Schema
    Block = Dry::Validation.Schema do
      configure do
        def self.messages
          super.merge(en: { errors: { hash: 'is in invalid format' }})
        end
      end

      required(:index).filled(:int?, gt?: 0)
      required(:time).filled(:time?)
      required(:hash).filled(:str?)
      required(:prev_hash).filled(:str?)
      required(:data).filled(:hash?)

      validate(hash: [:hash, :index]) do |hash, index|
        difficulty = RubyCoin::Block.difficulty_for(index)
        hash =~ /\A0{#{difficulty}}[a-z0-9]{#{64 - difficulty}}\z/i
      end
    end
  end
end
