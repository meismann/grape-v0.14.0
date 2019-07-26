# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class UnknownParameter < Base
      def initialize(param)
        super(message: compose_message('unknown_parameter', param: param))
      end
    end
  end
end
