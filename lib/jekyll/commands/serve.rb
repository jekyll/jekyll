# -*- encoding: utf-8 -*-
module Jekyll
  module Commands
    class Serve < Command

      class << self

        def init_with_program(prog)
          prog.command(:serve) do |c|
            c.syntax 'serve [options]'
            c.description 'Serve your site locally'
            c.alias :server
            c.alias :s

            add_build_options(c)

            c.option 'detach', '-B', '--detach', 'Run the server in the background (detach)'
            c.option 'port', '-P', '--port [PORT]', 'Port to listen on'
            c.option 'host', '-H', '--host [HOST]', 'Host to bind to'
            c.option 'baseurl', '-b', '--baseurl [URL]', 'Base URL'
            c.option 'skip_initial_build', '--skip-initial-build', 'Skips the initial site build which occurs before the server is started.'

            c.action do |args, options|
              options["serving"] = true
              options["watch"] = true unless options.key?("watch")
              Jekyll::Commands::Build.process(options)
              Jekyll::Commands::Serve.process(options)
            end
          end
        end

        # Boot up a WEBrick server which points to the compiled site's root.
        def process(options)
          options = configuration_from_options(options)
          destination = options['destination']
          setup(destination)

          s = WEBrick::HTTPServer.new(webrick_options(options))
          s.unmount("")

          s.mount(
            options['baseurl'],
            custom_file_handler,
            destination,
            file_handler_options
          )

          Jekyll.logger.info "Server address:", server_address(s, options)

          if options['detach'] # detach the server
            pid = Process.fork { s.start }
            Process.detach(pid)
            Jekyll.logger.info "Server detached with pid '#{pid}'.", "Run `pkill -f jekyll' or `kill -9 #{pid}' to stop the server."
          else # create a new server thread, then join it with current terminal
            t = Thread.new { s.start }
            trap("INT") { s.shutdown }
            t.join
          end
        end

        def setup(destination)
          require 'webrick'

          FileUtils.mkdir_p(destination)

          # monkey patch WEBrick using custom 404 page (/404.html)
          if File.exist?(File.join(destination, '404.html'))
            WEBrick::HTTPResponse.class_eval do
              def create_error_page
                @header['content-type'] = "text/html; charset=UTF-8"
                @body = IO.read(File.join(@config[:DocumentRoot], '404.html'))
              end
            end
          end
        end

        def webrick_options(config)
          opts = {
            :BindAddress        => config['host'],
            :DirectoryIndex     => %w(index.html index.htm index.cgi index.rhtml index.xml),
            :DocumentRoot       => config['destination'],
            :DoNotReverseLookup => true,
            :MimeTypes          => mime_types,
            :Port               => config['port'],
            :StartCallback      => start_callback(config['detach'])
          }

          if config['verbose']
            opts.merge!({
              :Logger => WEBrick::Log.new($stdout, WEBrick::Log::DEBUG)
            })
          else
            opts.merge!({
              :AccessLog => [],
              :Logger => WEBrick::Log.new([], WEBrick::Log::WARN)
            })
          end

          opts
        end

        # Custom WEBrick FileHandler servlet for serving "/file.html" at "/file"
        # when no exact match is found. This mirrors the behavior of GitHub
        # Pages and many static web server configs.
        def custom_file_handler
          Class.new WEBrick::HTTPServlet::FileHandler do
            def search_file(req, res, basename)
              if file = super
                file
              else
                super(req, res, "#{basename}.html")
              end
            end
          end
        end

        def start_callback(detached)
          unless detached
            Proc.new { Jekyll.logger.info "Server running...", "press ctrl-c to stop." }
          end
        end

        def mime_types
          mime_types_file = File.expand_path('../mime.types', File.dirname(__FILE__))
          WEBrick::HTTPUtils::load_mime_types(mime_types_file)
        end

        def server_address(server, options)
          baseurl = "#{options['baseurl']}/" if options['baseurl']
          [
            "http://",
            server.config[:BindAddress],
            ":",
            server.config[:Port],
            baseurl || ""
          ].map(&:to_s).join("")
        end

        # recreate NondisclosureName under utf-8 circumstance
        def file_handler_options
          WEBrick::Config::FileHandler.merge({
            :FancyIndexing     => true,
            :NondisclosureName => ['.ht*','~*']
          })
        end

      end

    end
  end
end
