require "webrick"

module Jekyll
  module Commands
    class Serve
      class Servlet < WEBrick::HTTPServlet::FileHandler
        HEADER_DEFAULTS = {}

        def initialize(server, root, callbacks)
          extract_headers(server.config[:JekyllOptions])
          super
        end

        #

        def do_GET(req, res)
          res.header.merge!(@headers) if @headers.any?
          return super
        end

        # ---------------------------------------------------------------------
        # file > file/index.html > file.html > directory -> Having a directory
        # with the same name as a file will result in the file being served the
        # way that Nginx behaves (probably not exactly...) For browsing.
        # ---------------------------------------------------------------------

        def search_file(req, res, basename)
          return file if (file = super) || (file = super req, res, "#{basename}.html")

          file = "#{req.path.gsub(/\/\Z/, "")}.html"
          if file && File.file?(File.join(@config[:DocumentRoot], file))
            return ".html"
          end
        nil
        end

        def extract_headers(opts)
          @headers = add_defaults(opts.fetch("webrick", {}).fetch("headers", {}))
        end

        def add_defaults(opts)
          control_development_cache(opts)
          HEADER_DEFAULTS.each_with_object(opts) do |(k, v), h|
            h[k] = v if !h[k]
          end
        end

        def control_development_cache(opts)
          if !opts.has_key?("Cache-Control") && Jekyll.env == "development"
            opts["Cache-Control"] = "private, max-age=0, proxy-revalidate, no-store, no-cache, must-revalidate"
          end
        end
      end
    end
  end
end
