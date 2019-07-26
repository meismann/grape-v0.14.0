require 'grape_v0_14_0/middleware/base'

module GrapeV0_14_0
  module Middleware
    class Globals < Base
      def before
        request = GrapeV0_14_0::Request.new(@env)
        @env[GrapeV0_14_0::Env::GRAPE_REQUEST] = request
        @env[GrapeV0_14_0::Env::GRAPE_REQUEST_HEADERS] = request.headers
        @env[GrapeV0_14_0::Env::GRAPE_REQUEST_PARAMS] = request.params if @env[GrapeV0_14_0::Env::RACK_INPUT]
      end
    end
  end
end
