# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class UnknownOptions < Base
      def initialize(options)
        super(message: compose_message('unknown_options', options: options))
      end
    end
  end
end
