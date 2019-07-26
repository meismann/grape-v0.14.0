module GrapeV0_14_0
  module Middleware
    # This is a simple middleware for adding before and after filters
    # to GrapeV0_14_0 APIs. It is used like so:
    #
    #     use GrapeV0_14_0::Middleware::Filter, before: -> { do_something }, after: -> { do_something }
    class Filter < Base
      def before
        app.instance_eval(&options[:before]) if options[:before]
      end

      def after
        app.instance_eval(&options[:after]) if options[:after]
      end
    end
  end
end
