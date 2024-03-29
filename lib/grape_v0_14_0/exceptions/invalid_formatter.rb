# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class InvalidFormatter < Base
      def initialize(klass, to_format)
        super(message: compose_message('invalid_formatter', klass: klass, to_format: to_format))
      end
    end
  end
end
