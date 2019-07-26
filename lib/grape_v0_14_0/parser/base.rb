module GrapeV0_14_0
  module Parser
    module Base
      class << self
        PARSERS = {
          json: GrapeV0_14_0::Parser::Json,
          jsonapi: GrapeV0_14_0::Parser::Json,
          xml: GrapeV0_14_0::Parser::Xml
        }

        def parsers(options)
          PARSERS.merge(options[:parsers] || {})
        end

        def parser_for(api_format, options = {})
          spec = parsers(options)[api_format]
          case spec
          when nil
            nil
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
