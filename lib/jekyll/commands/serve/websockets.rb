# frozen_string_literal: true

require "http/parser"

module Jekyll
  module Commands
    class Serve
      # The LiveReload protocol requires the server to serve livereload.js over HTTP
      # despite the fact that the protocol itself uses WebSockets.  This custom connection
      # class addresses the dual protocols that the server needs to understand.
      class HttpAwareConnection < EventMachine::WebSocket::Connection
        attr_reader :reload_body, :reload_size

        def initialize(_opts)
          # If EventMachine SSL support on Windows ever gets better, the code below will
          # set up the reactor to handle SSL
          #
          # @ssl_enabled = opts["ssl_cert"] && opts["ssl_key"]
          # if @ssl_enabled
          #   em_opts[:tls_options] = {
          #   :private_key_file => Jekyll.sanitized_path(opts["source"], opts["ssl_key"]),
          #   :cert_chain_file  => Jekyll.sanitized_path(opts["source"], opts["ssl_cert"])
          #   }
          #   em_opts[:secure] = true
          # end

          # This is too noisy even for --verbose, but uncomment if you need it for
          # a specific WebSockets issue.  Adding ?LR-verbose=true onto the URL will
          # enable logging on the client side.
          # em_opts[:debug] = true

          em_opts = {}
          super(em_opts)

          reload_file = File.join(Serve.singleton_class::LIVERELOAD_DIR, "livereload.js")

          @reload_body = File.read(reload_file)
          @reload_size = @reload_body.bytesize
        end

        # rubocop:disable Metrics/MethodLength
        def dispatch(data)
          parser = Http::Parser.new
          parser << data

          # WebSockets requests will have a Connection: Upgrade header
          if parser.http_method != "GET" || parser.upgrade?
            super
          elsif parser.request_url =~ %r!^\/livereload.js!
            headers = [
              "HTTP/1.1 200 OK",
              "Content-Type: application/javascript",
              "Content-Length: #{reload_size}",
              "",
              "",
            ].join("\r\n")
            send_data(headers)

            # stream_file_data would free us from keeping livereload.js in memory
            # but JRuby blocks on that call and never returns
            send_data(reload_body)
            close_connection_after_writing
          else
            body = "This port only serves livereload.js over HTTP.\n"
            headers = [
              "HTTP/1.1 400 Bad Request",
              "Content-Type: text/plain",
              "Content-Length: #{body.bytesize}",
              "",
              "",
            ].join("\r\n")
            send_data(headers)
            send_data(body)
            close_connection_after_writing
          end
        end
      end
    end
  end
end
