# encoding: utf-8
module GrapeV0_14_0
  module Exceptions
    class MissingVendorOption < Base
      def initialize
        super(message: compose_message('missing_vendor_option'))
      end
    end
  end
end
