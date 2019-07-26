module GrapeV0_14_0
  module Parser
    module Json
      class << self
        def call(object, _env)
          MultiJson.load(object)
        rescue MultiJson::ParseError
          # handle JSON parsing errors via the rescue handlers or provide error message
          raise GrapeV0_14_0::Exceptions::InvalidMessageBody, 'application/json'
        end
      end
    end
  end
end
