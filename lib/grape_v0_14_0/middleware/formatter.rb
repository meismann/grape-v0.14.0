require 'grape_v0_14_0/middleware/base'

module GrapeV0_14_0
  module Middleware
    class Formatter < Base
      CHUNKED = 'chunked'.freeze

      def default_options
        {
          default_format: :txt,
          formatters: {},
          parsers: {}
        }
      end

      def before
        negotiate_content_type
        read_body_input
      end

      def after
        status, headers, bodies = *@app_response

        if Rack::Utils::STATUS_WITH_NO_ENTITY_BODY.include?(status)
          @app_response
        else
          build_formatted_response(status, headers, bodies)
        end
      end

      private

      def build_formatted_response(status, headers, bodies)
        headers = ensure_content_type(headers)

        if bodies.is_a?(GrapeV0_14_0::Util::FileResponse)
          Rack::Response.new([], status, headers) do |resp|
            resp.body = bodies.file
          end
        else
          # Allow content-type to be explicitly overwritten
          formatter = fetch_formatter(headers, options)
          bodymap = bodies.collect { |body| formatter.call(body, env) }
          Rack::Response.new(bodymap, status, headers)
        end
      rescue GrapeV0_14_0::Exceptions::InvalidFormatter => e
        throw :error, status: 500, message: e.message
      end

      def fetch_formatter(headers, options)
        api_format = mime_types[headers[GrapeV0_14_0::Http::Headers::CONTENT_TYPE]] || env[GrapeV0_14_0::Env::API_FORMAT]
        GrapeV0_14_0::Formatter::Base.formatter_for(api_format, options)
      end

      # Set the content type header for the API format if it is not already present.
      #
      # @param headers [Hash]
      # @return [Hash]
      def ensure_content_type(headers)
        if headers[GrapeV0_14_0::Http::Headers::CONTENT_TYPE]
          headers
        else
          headers.merge(GrapeV0_14_0::Http::Headers::CONTENT_TYPE => content_type_for(env[GrapeV0_14_0::Env::API_FORMAT]))
        end
      end

      def request
        @request ||= Rack::Request.new(env)
      end

      # store read input in env['api.request.input']
      def read_body_input
        return unless
          (request.post? || request.put? || request.patch? || request.delete?) &&
          (!request.form_data? || !request.media_type) &&
          (!request.parseable_data?) &&
          (request.content_length.to_i > 0 || request.env[GrapeV0_14_0::Http::Headers::HTTP_TRANSFER_ENCODING] == CHUNKED)

        return unless (input = env[GrapeV0_14_0::Env::RACK_INPUT])

        input.rewind
        body = env[GrapeV0_14_0::Env::API_REQUEST_INPUT] = input.read
        begin
          read_rack_input(body) if body && body.length > 0
        ensure
          input.rewind
        end
      end

      # store parsed input in env['api.request.body']
      def read_rack_input(body)
        fmt = mime_types[request.media_type] if request.media_type
        fmt ||= options[:default_format]
        if content_type_for(fmt)
          parser = GrapeV0_14_0::Parser::Base.parser_for fmt, options
          if parser
            begin
              body = (env[GrapeV0_14_0::Env::API_REQUEST_BODY] = parser.call(body, env))
              if body.is_a?(Hash)
                if env[GrapeV0_14_0::Env::RACK_REQUEST_FORM_HASH]
                  env[GrapeV0_14_0::Env::RACK_REQUEST_FORM_HASH] = env[GrapeV0_14_0::Env::RACK_REQUEST_FORM_HASH].merge(body)
                else
                  env[GrapeV0_14_0::Env::RACK_REQUEST_FORM_HASH] = body
                end
                env[GrapeV0_14_0::Env::RACK_REQUEST_FORM_INPUT] = env[GrapeV0_14_0::Env::RACK_INPUT]
              end
            rescue GrapeV0_14_0::Exceptions::Base => e
              raise e
            rescue StandardError => e
              throw :error, status: 400, message: e.message
            end
          else
            env[GrapeV0_14_0::Env::API_REQUEST_BODY] = body
          end
        else
          throw :error, status: 406, message: "The requested content-type '#{request.media_type}' is not supported."
        end
      end

      def negotiate_content_type
        fmt = format_from_extension || format_from_params || options[:format] || format_from_header || options[:default_format]
        if content_type_for(fmt)
          env[GrapeV0_14_0::Env::API_FORMAT] = fmt
        else
          throw :error, status: 406, message: "The requested format '#{fmt}' is not supported."
        end
      end

      def format_from_extension
        parts = request.path.split('.')

        if parts.size > 1
          extension = parts.last
          # avoid symbol memory leak on an unknown format
          return extension.to_sym if content_type_for(extension)
        end
        nil
      end

      def format_from_params
        fmt = Rack::Utils.parse_nested_query(env[GrapeV0_14_0::Http::Headers::QUERY_STRING])[GrapeV0_14_0::Http::Headers::FORMAT]
        # avoid symbol memory leak on an unknown format
        return fmt.to_sym if content_type_for(fmt)
        fmt
      end

      def format_from_header
        mime_array.each do |t|
          return mime_types[t] if mime_types.key?(t)
        end
        nil
      end

      def mime_array
        accept = env[GrapeV0_14_0::Http::Headers::HTTP_ACCEPT]
        return [] unless accept

        accept_into_mime_and_quality = %r{
          (
            \w+/[\w+.-]+)     # eg application/vnd.example.myformat+xml
          (?:
           (?:;[^,]*?)?       # optionally multiple formats in a row
           ;\s*q=([\d.]+)     # optional "quality" preference (eg q=0.5)
          )?
        }x

        vendor_prefix_pattern = /vnd\.[^+]+\+/

        accept.scan(accept_into_mime_and_quality)
          .sort_by { |_, quality_preference| -quality_preference.to_f }
          .flat_map { |mime, _| [mime, mime.sub(vendor_prefix_pattern, '')] }
      end
    end
  end
end
