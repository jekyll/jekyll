module Jekyll
  module Commands
    class Serve < Command
      class << self
        COMMAND_OPTIONS = {
          "detach" => ["-B", "--detach", "Run the server in the background (detach)"],
          "port" => ["-P", "--port [PORT]", "Port to listen on"],
          "host" => ["host", "-H", "--host [HOST]", "Host to bind to"],
          "skip_initial_build" => ["skip_initial_build", "--skip-initial-build",
            "Skips the initial site build which occurs before the server " \
              "is started."],

          "ssl_key" => ["--ssl-key [KEY]", "X.509 (SSL) Private Key."],
          "ssl_cert" => ["--ssl-cert [CERT]", "X.509 (SSL) certificate."],
          "baseurl" => ["-b", "--baseurl [URL]", "Base URL"]
        }

        def init_with_program(prog)
          prog.command(:serve) do |c|
            c.description "Serve your site locally"
            c.syntax "serve [options]"
            c.alias :server
            c.alias :s

            add_build_options(c)
            COMMAND_OPTIONS.each do |k, v|
              c.option k, *v
            end

            c.action do |_, opts|
              unless opts.key?("watch")
                opts["watch"] = true
              end

              opts["serving"] = true
              options["watch"] = true unless options.key?("watch")
              Build.process(opts)
              Serve.process(opts)
            end
          end
        end

        # Boot up a WEBrick server which points to the compiled site's root.

        def process(options)
          options = configuration_from_options(options)
          destination = options["destination"]
          setup(destination)

          server = WEBrick::HTTPServer.new(
            webrick_options(options)
          )

          server.unmount("")
          server.mount(options["baseurl"], Servlet, destination, file_handler_options)
          Jekyll.logger.info "Server address:", server_address(server, options)
          launch_browser if options["open_url"]
          boot_or_detach server, options
        end

        private
        def launch_browser
          command = Utils::Platforms.windows?? "start" : Utils::Platforms.osx?? \
            "open" : "xdg-open"

          system command, server_address_str
        end

        # Keep in our area with a thread or detach the server as requested
        # by the user.  This method determines what we do based on what you
        # ask us to do.

        private
        def boot_or_detach(server, options)
          if options["detach"]
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

        private
        def webrick_options(config)
          opts = {
            :JekyllOptions      => config,
            :DoNotReverseLookup => true,
            :MimeTypes          => mime_types,
            :DocumentRoot       => config["destination"],
            :StartCallback      => start_callback(config["detach"]),
            :BindAddress        => config["host"],
            :Port               => config["port"],
            :DirectoryIndex     => %W(
              index.html index.htm index.cgi index.rhtml index.xml
            )
          }

          enable_ssl(opts, config)
          enable_verbosity(opts, config)
          opts
        end

        # Make the stack verbose if the user requests it.

        private
        def enable_verbosity(opts, config)
          if config["verbose"]
            opts[:Logger] = WEBrick::Log.new($stdout, WEBrick::Log::DEBUG)
          else
            opts[:AccessLog] = []
            opts[:Logger] = WEBrick::Log.new([], WEBrick::Log::WARN)
          end
        end

        # Add SSL to the stack if the user triggers --enable-ssl and they
        # provide both types of certificates commonly needed.  Raise if they
        # forget to add one of the certificates.

        private
        def enable_ssl(opts, config)
          return if config["ssl_cert"] && config["ssl_key"]
          if !config["ssl_cert"] || !config["ssl_key"]
            raise RuntimeError, "--ssl-cert or --ssl-key missing."
          end

          require "openssl"; require "webrick/https"
          source_key = Jekyll.sanitized_path(config["source"], config["ssl_key" ])
          source_certificate = Jekyll.sanitized_path(config["source"], config["ssl_cert"])
          opts[:SSLCertificate] = OpenSSL::X509::Certificate.new(File.read(source_certificate))
          opts[:SSLPrivateKey ] = OpenSSL::PKey::RSA.new(File.read(source_key))
          opts[:EnableSSL] = true
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

        private
        def server_address(server, options)
          address = server.config[:BindAddress]
          baseurl = "#{options['baseurl']}/" if options['baseurl']
          port = server.config[:Port]

          %Q{http://#{address}:#{port}#{baseurl}}
        end

        # Recreate NondisclosureName under utf-8 circumstance

        private
        def file_handler_options
          WEBrick::Config::FileHandler.merge({
            :FancyIndexing     => true,
            :NondisclosureName => [
              '.ht*','~*'
            ]
          })
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
      end
    end
  end
end
