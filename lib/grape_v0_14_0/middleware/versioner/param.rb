require 'grape_v0_14_0/middleware/base'

module GrapeV0_14_0
  module Middleware
    module Versioner
      # This middleware sets various version related rack environment variables
      # based on the request parameters and removes that parameter from the
      # request parameters for subsequent middleware and API.
      # If the version substring does not match any potential initialized
      # versions, a 404 error is thrown.
      # If the version substring is not passed the version (highest mounted)
      # version will be used.
      #
      # Example: For a uri path
      #   /resource?apiver=v1
      #
      # The following rack env variables are set and path is rewritten to
      # '/resource':
      #
      #   env['api.version'] => 'v1'
      class Param < Base
        def default_options
          {
            parameter: 'apiver'.freeze
          }
        end

        def before
          paramkey = options[:parameter]
          potential_version = Rack::Utils.parse_nested_query(env[GrapeV0_14_0::Http::Headers::QUERY_STRING])[paramkey]
          return if potential_version.nil?
          throw :error, status: 404, message: '404 API Version Not Found', headers: { GrapeV0_14_0::Http::Headers::X_CASCADE => 'pass' } if options[:versions] && !options[:versions].find { |v| v.to_s == potential_version }
          env[GrapeV0_14_0::Env::API_VERSION] = potential_version
          env[GrapeV0_14_0::Env::RACK_REQUEST_QUERY_HASH].delete(paramkey) if env.key? GrapeV0_14_0::Env::RACK_REQUEST_QUERY_HASH
        end
      end
    end
  end
end
