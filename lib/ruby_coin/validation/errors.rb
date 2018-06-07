# frozen_string_literal: true

module RubyCoin
  module Validation
    module Errors
      class ValidationError < StandardError
        attr_reader :errors
        def initialize(errors, message)
          super(message)
          @errors = errors
        end
      end

      class InvalidBlock < ValidationError
        def initialize(errors)
          super(errors, 'Block is invalid')
        end
      end

      class BrokenChain < ValidationError
        def initialize(errors)
          super(errors, 'Chain is broken')
        end
      end

      class InvalidTransaction < ValidationError
        def initialize(errors)
          super(errors, 'Transaction is invalid')
        end
      end

      class InvalidAction < ValidationError
        def initialize(errors)
          super(errors, 'Action is invalid')
        end
      end
    end
  end
end
