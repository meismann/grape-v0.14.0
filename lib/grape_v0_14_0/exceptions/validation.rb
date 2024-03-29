require 'grape_v0_14_0/exceptions/base'

module GrapeV0_14_0
  module Exceptions
    class Validation < GrapeV0_14_0::Exceptions::Base
      attr_accessor :params

      def initialize(args = {})
        fail 'Params are missing:' unless args.key? :params
        @params = args[:params]
        args[:message] = translate_message(args[:message_key]) if args.key? :message_key
        super
      end

      # remove all the unnecessary stuff from GrapeV0_14_0::Exceptions::Base like status
      # and headers when converting a validation error to json or string
      def as_json(*_args)
        to_s
      end

      def to_s
        message
      end
    end
  end
end
