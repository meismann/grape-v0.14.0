# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class InvalidVersionerOption < Base
      def initialize(strategy)
        super(message: compose_message('invalid_versioner_option', strategy: strategy))
      end
    end
  end
end
