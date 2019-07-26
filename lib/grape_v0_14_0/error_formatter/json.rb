module GrapeV0_14_0
  module ErrorFormatter
    module Json
      class << self
        def call(message, backtrace, options = {}, env = nil)
          message = GrapeV0_14_0::ErrorFormatter::Base.present(message, env)

          result = message.is_a?(String) ? { error: message } : message
          if (options[:rescue_options] || {})[:backtrace] && backtrace && !backtrace.empty?
            result = result.merge(backtrace: backtrace)
          end
          MultiJson.dump(result)
        end
      end
    end
  end
end
