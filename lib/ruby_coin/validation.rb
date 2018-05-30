# frozen_string_literal: true

module RubyCoin
  module Validation
    Block = Dry::Validation.Schema do
      required(:index).filled(:int?, gt?: 0)
      required(:time).filled(:time?)
      required(:hash).filled(:str?)
      required(:data).filled(:str?)
    end
  end
end
