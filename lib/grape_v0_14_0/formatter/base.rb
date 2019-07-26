module GrapeV0_14_0
  module Formatter
    module Base
      class << self
        FORMATTERS = {
          json: GrapeV0_14_0::Formatter::Json,
          jsonapi: GrapeV0_14_0::Formatter::Json,
          serializable_hash: GrapeV0_14_0::Formatter::SerializableHash,
          txt: GrapeV0_14_0::Formatter::Txt,
          xml: GrapeV0_14_0::Formatter::Xml
        }

        def formatters(options)
          FORMATTERS.merge(options[:formatters] || {})
        end

        def formatter_for(api_format, options = {})
          spec = formatters(options)[api_format]
          case spec
          when nil
            ->(obj, _env) { obj }
          when Symbol
            method(spec)
          else
            spec
          end
        end
      end
    end
  end
end
