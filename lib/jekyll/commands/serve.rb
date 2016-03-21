module Jekyll
  module Commands
    class Serve < Command
      class << self
        COMMAND_OPTIONS = {
          "ssl_cert" => ["--ssl-cert [CERT]", "X.509 (SSL) certificate."],
          "host"     => ["host", "-H", "--host [HOST]", "Host to bind to"],
          "open_url" => ["-o", "--open-url", "Launch your browser with your site."],
          "detach"   => ["-B", "--detach", "Run the server in the background (detach)"],
          "ssl_key"  => ["--ssl-key [KEY]", "X.509 (SSL) Private Key."],
          "port"     => ["-P", "--port [PORT]", "Port to listen on"],
          "baseurl"  => ["-b", "--baseurl [URL]", "Base URL"],
          "skip_initial_build" => ["skip_initial_build", "--skip-initial-build",
            "Skips the initial site build which occurs before the server is started."]
        }

        #

        def init_with_program(prog)
          prog.command(:serve) do |cmd|
            cmd.description "Serve your site locally"
            cmd.syntax "serve [options]"
            cmd.alias :server
            cmd.alias :s

            add_build_options(cmd)
            COMMAND_OPTIONS.each do |key, val|
              cmd.option key, *val
            end

            cmd.action do |_, opts|
              opts["serving"] = true
              opts["watch"  ] = true unless opts.key?("watch")
              Build.process(opts)
              Serve.process(opts)
            end
          end
        end

        #

        def process(opts)
          opts = configuration_from_options(opts)
          destination = opts["destination"]
          setup(destination)

          server = WEBrick::HTTPServer.new(webrick_opts(opts)).tap { |o| o.unmount("") }
          server.mount(opts["baseurl"], Servlet, destination, file_handler_opts)
          Jekyll.logger.info "Server address:", server_address(server, opts)
          launch_browser server, opts if opts["open_url"]
          boot_or_detach server, opts
        end

        # Do a base pre-setup of WEBRick so that everything is in place
        # when we get ready to party, checking for an setting up an error page
        # and making sure our destination exists.

        private
        def setup(destination)
          require_relative "serve/servlet"

          FileUtils.mkdir_p(destination)
          if File.exist?(File.join(destination, "404.html"))
            WEBrick::HTTPResponse.class_eval do
              def create_error_page
                @header["Content-Type"] = "text/html; charset=UTF-8"
                @body = IO.read(File.join(@config[:DocumentRoot], "404.html"))
              end
            end
          end
        end

        #

        private
        def webrick_opts(opts)
          opts = {
            :JekyllOptions      => opts,
            :DoNotReverseLookup => true,
            :MimeTypes          => mime_types,
            :DocumentRoot       => opts["destination"],
            :StartCallback      => start_callback(opts["detach"]),
            :BindAddress        => opts["host"],
            :Port               => opts["port"],
            :DirectoryIndex     => %W(
              index.htm
              index.html
              index.rhtml
              index.cgi
              index.xml
            )
          }

          enable_ssl(opts)
          enable_logging(opts)
          opts
        end

        # Recreate NondisclosureName under utf-8 circumstance

        private
        def file_handler_opts
          WEBrick::Config::FileHandler.merge({
            :FancyIndexing     => true,
            :NondisclosureName => [
              '.ht*', '~*'
            ]
          })
        end

        #

        private
        def server_address(server, opts)
          "%{prefix}://%{address}:%{port}%{baseurl}" % {
            :prefix => server.config[:SSLEnable] ? "https" : "http",
            :baseurl => opts["baseurl"] ? "#{opts["baseurl"]}/" : "",
            :address => server.config[:BindAddress],
            :port => server.config[:Port]
          }
        end

        #

        private
        def launch_browser(server, opts)
          command =
            if Utils::Platforms.windows?
              "start"
            elsif Utils::Platforms.osx?
              "open"
            else
              "xdg-open"
            end
          system command, server_address(server, opts)
        end

        # Keep in our area with a thread or detach the server as requested
        # by the user.  This method determines what we do based on what you
        # ask us to do.

        private
        def boot_or_detach(server, opts)
          if opts["detach"]
            pid = Process.fork do
              server.start
            end

            Process.detach(pid)
            Jekyll.logger.info "Server detached with pid '#{pid}'.", \
              "Run `pkill -f jekyll' or `kill -9 #{pid}' to stop the server."
          else
            t = Thread.new { server.start }
            trap("INT") { server.shutdown }
            t.join
          end
        end

        # Make the stack verbose if the user requests it.

        private
        def enable_logging(opts)
          opts[:AccessLog] = []
          level = WEBrick::Log.const_get(opts[:JekyllOptions]["verbose"] ? :DEBUG : :WARN)
          opts[:Logger] = WEBrick::Log.new($stdout, level)
        end

        # Add SSL to the stack if the user triggers --enable-ssl and they
        # provide both types of certificates commonly needed.  Raise if they
        # forget to add one of the certificates.

        private
        def enable_ssl(opts)
          return if !opts[:JekyllOptions]["ssl_cert"] && !opts[:JekyllOptions]["ssl_key"]
          if !opts[:JekyllOptions]["ssl_cert"] || !opts[:JekyllOptions]["ssl_key"]
            raise RuntimeError, "--ssl-cert or --ssl-key missing."
          end

          require "openssl"
          require "webrick/https"
          source_key = Jekyll.sanitized_path(opts[:JekyllOptions]["source"], opts[:JekyllOptions]["ssl_key" ])
          source_certificate = Jekyll.sanitized_path(opts[:JekyllOptions]["source"], opts[:JekyllOptions]["ssl_cert"])
          opts[:SSLCertificate] = OpenSSL::X509::Certificate.new(File.read(source_certificate))
          opts[:SSLPrivateKey ] = OpenSSL::PKey::RSA.new(File.read(source_key))
          opts[:SSLEnable] = true
        end

        private
        def start_callback(detached)
          unless detached
            proc do
              Jekyll.logger.info("Server running...", "press ctrl-c to stop.")
            end
          end
        end

        private
        def mime_types
          file = File.expand_path('../mime.types', File.dirname(__FILE__))
          WEBrick::HTTPUtils.load_mime_types(file)
        end
      end
    end
  end
end
