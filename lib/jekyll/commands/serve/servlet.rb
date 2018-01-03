# frozen_string_literal: true

require "webrick"

module Jekyll
  module Commands
    class Serve
      # This class is used to determine if the Servlet should modify a served file
      # to insert the LiveReload script tags
      class SkipAnalyzer
        BAD_USER_AGENTS = [%r!MSIE!].freeze

        def self.skip_processing?(request, response, options)
          new(request, response, options).skip_processing?
        end

        def initialize(request, response, options)
          @options = options
          @request = request
          @response = response
        end

        def skip_processing?
          !html? || chunked? || inline? || bad_browser?
        end

        def chunked?
          @response["Transfer-Encoding"] == "chunked"
        end

        def inline?
          @response["Content-Disposition"] =~ %r!^inline!
        end

        def bad_browser?
          BAD_USER_AGENTS.any? { |pattern| @request["User-Agent"] =~ pattern }
        end

        def html?
          @response["Content-Type"] =~ %r!text/html!
        end
      end

      # This class inserts the LiveReload script tags into HTML as it is served
      class BodyProcessor
        HEAD_TAG_REGEX = %r!<head>|<head[^(er)][^<]*>!

        attr_reader :content_length, :new_body, :livereload_added

        def initialize(body, options)
          @body = body
          @options = options
          @processed = false
        end

        def processed?
          @processed
        end

        # rubocop:disable Metrics/MethodLength
        def process!
          @new_body = []
          # @body will usually be a File object but Strings occur in rare cases
          if @body.respond_to?(:each)
            begin
              @body.each { |line| @new_body << line.to_s }
            ensure
              @body.close
            end
          else
            @new_body = @body.lines
          end

          @content_length = 0
          @livereload_added = false

          @new_body.each do |line|
            if !@livereload_added && line["<head"]
              line.gsub!(HEAD_TAG_REGEX) do |match|
                %(#{match}#{template.result(binding)})
              end

              @livereload_added = true
            end

            @content_length += line.bytesize
            @processed = true
          end
          @new_body = @new_body.join
        end
        # rubocop:enable Metrics/MethodLength

        def template
          # Unclear what "snipver" does. Doc at
          # https://github.com/livereload/livereload-js states that the recommended
          # setting is 1.

          # Complicated JavaScript to ensure that livereload.js is loaded from the
          # same origin as the page.  Mostly useful for dealing with the browser's
          # distinction between 'localhost' and 127.0.0.1
          template = <<-TEMPLATE
          <script>
            document.write(
              '<script src="http://' +
              (location.host || 'localhost').split(':')[0] +
              ':<%=@options["livereload_port"] %>/livereload.js?snipver=1<%= livereload_args %>"' +
              '></' +
              'script>');
          </script>
          TEMPLATE
          ERB.new(Jekyll::Utils.strip_heredoc(template))
        end

        def livereload_args
          # XHTML standard requires ampersands to be encoded as entities when in
          # attributes. See http://stackoverflow.com/a/2190292
          src = ""
          if @options["livereload_min_delay"]
            src += "&amp;mindelay=#{@options["livereload_min_delay"]}"
          end
          if @options["livereload_max_delay"]
            src += "&amp;maxdelay=#{@options["livereload_max_delay"]}"
          end
          if @options["livereload_port"]
            src += "&amp;port=#{@options["livereload_port"]}"
          end
          src
        end
      end

      class Servlet < WEBrick::HTTPServlet::FileHandler
        DEFAULTS = {
          "Cache-Control" => "private, max-age=0, proxy-revalidate, " \
            "no-store, no-cache, must-revalidate",
        }.freeze

        def initialize(server, root, callbacks)
          # So we can access them easily.
          @jekyll_opts = server.config[:JekyllOptions]
          set_defaults
          super
        end

        def search_index_file(req, res)
          super || search_file(req, res, ".html")
        end

        # Add the ability to tap file.html the same way that Nginx does on our
        # Docker images (or on GitHub Pages.) The difference is that we might end
        # up with a different preference on which comes first.

        def search_file(req, res, basename)
          # /file.* > /file/index.html > /file.html
          super || super(req, res, "#{basename}.html")
        end

        # rubocop:disable Naming/MethodName
        def do_GET(req, res)
          rtn = super

          if @jekyll_opts["livereload"]
            return rtn if SkipAnalyzer.skip_processing?(req, res, @jekyll_opts)

            processor = BodyProcessor.new(res.body, @jekyll_opts)
            processor.process!
            res.body = processor.new_body
            res.content_length = processor.content_length.to_s

            if processor.livereload_added
              # Add a header to indicate that the page content has been modified
              res["X-Rack-LiveReload"] = "1"
            end
          end

          validate_and_ensure_charset(req, res)
          res.header.merge!(@headers)
          rtn
        end
        # rubocop:enable Naming/MethodName

        #

        private
        def validate_and_ensure_charset(_req, res)
          key = res.header.keys.grep(%r!content-type!i).first
          typ = res.header[key]

          unless typ =~ %r!;\s*charset=!
            res.header[key] = "#{typ}; charset=#{@jekyll_opts["encoding"]}"
          end
        end

        #

        private
        def set_defaults
          hash_ = @jekyll_opts.fetch("webrick", {}).fetch("headers", {})
          DEFAULTS.each_with_object(@headers = hash_) do |(key, val), hash|
            hash[key] = val unless hash.key?(key)
          end
        end
      end
    end
  end
end
