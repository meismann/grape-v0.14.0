# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class MissingMimeType < Base
      def initialize(new_format)
        super(message: compose_message('missing_mime_type', new_format: new_format))
      end
    end
  end
end
