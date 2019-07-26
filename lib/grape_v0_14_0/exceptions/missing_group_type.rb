# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class MissingGroupTypeError < Base
      def initialize
        super(message: compose_message('missing_group_type'))
      end
    end
  end
end
