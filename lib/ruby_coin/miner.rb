# frozen_string_literal: true

module RubyCoin
  module Miner
    extend ActiveSupport::Autoload

    autoload :CalculateProofOfWork
    autoload :Worker
    autoload :Workers
    autoload :Master
  end
end
