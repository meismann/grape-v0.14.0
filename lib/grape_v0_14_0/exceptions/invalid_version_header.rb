# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class InvalidVersionHeader < Base
      def initialize(message, headers)
        super(message: compose_message('invalid_version_header', message: message), status: 406, headers: headers)
      end
    end
  end
end
