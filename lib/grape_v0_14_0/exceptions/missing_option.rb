# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class MissingOption < Base
      def initialize(option)
        super(message: compose_message('missing_option', option: option))
      end
    end
  end
end
