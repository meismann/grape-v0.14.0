require 'rack/auth/basic'

module GrapeV0_14_0
  module Middleware
    module Auth
      class Base
        attr_accessor :options, :app, :env

        def initialize(app, options = {})
          @app = app
          @options = options || {}
        end

        def context
          env[GrapeV0_14_0::Env::API_ENDPOINT]
        end

        def call(env)
          dup._call(env)
        end

        def _call(env)
          self.env = env

          if options.key?(:type)
            auth_proc         = options[:proc]
            auth_proc_context = context

            strategy_info = GrapeV0_14_0::Middleware::Auth::Strategies[options[:type]]

            throw(:error, status: 401, message: 'API Authorization Failed.') unless strategy_info.present?

            strategy = strategy_info.create(@app, options) do |*args|
              auth_proc_context.instance_exec(*args, &auth_proc)
            end

            strategy.call(env)

          else
            app.call(env)
          end
        end
      end
    end
  end
end
