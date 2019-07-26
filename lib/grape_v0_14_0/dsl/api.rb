require 'active_support/concern'

module GrapeV0_14_0
  module DSL
    module API
      extend ActiveSupport::Concern

      include GrapeV0_14_0::Middleware::Auth::DSL

      include GrapeV0_14_0::DSL::Validations
      include GrapeV0_14_0::DSL::Callbacks
      include GrapeV0_14_0::DSL::Configuration
      include GrapeV0_14_0::DSL::Helpers
      include GrapeV0_14_0::DSL::Middleware
      include GrapeV0_14_0::DSL::RequestResponse
      include GrapeV0_14_0::DSL::Routing
    end
  end
end
