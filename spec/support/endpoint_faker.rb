module Spec
  module Support
    class EndpointFaker
      class FakerAPI < GrapeV0_14_0::API
        get '/' do
        end
      end

      def initialize(app, endpoint = FakerAPI.endpoints.first)
        @app = app
        @endpoint = endpoint
      end

      def call(env)
        @endpoint.instance_exec do
          @request = GrapeV0_14_0::Request.new(env.dup)
        end

        @app.call(env.merge('api.endpoint' => @endpoint))
      end
    end
  end
end
