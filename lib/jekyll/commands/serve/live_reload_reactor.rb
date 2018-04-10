# frozen_string_literal: true

require "em-websocket"

require_relative "websockets"

module Jekyll
  module Commands
    class Serve
      class LiveReloadReactor
        attr_reader :started_event
        attr_reader :stopped_event
        attr_reader :thread

        def initialize
          @websockets = []
          @connections_count = 0
          @started_event = Utils::ThreadEvent.new
          @stopped_event = Utils::ThreadEvent.new
        end

        def stop
          # There is only one EventMachine instance per Ruby process so stopping
          # it here will stop the reactor thread we have running.
          EM.stop if EM.reactor_running?
          Jekyll.logger.debug "LiveReload Server:", "halted"
        end

        def running?
          EM.reactor_running?
        end

        def handle_websockets_event(websocket)
          websocket.onopen { |handshake| connect(websocket, handshake) }
          websocket.onclose { disconnect(websocket) }
          websocket.onmessage { |msg| print_message(msg) }
          websocket.onerror { |error| log_error(error) }
        end

        def start(opts)
          @thread = Thread.new do
            # Use epoll if the kernel supports it
            EM.epoll
            EM.run do
              EM.error_handler { |e| log_error(e) }

              EM.start_server(
                opts["host"],
                opts["livereload_port"],
                HttpAwareConnection,
                opts
              ) do |ws|
                handle_websockets_event(ws)
              end

              # Notify blocked threads that EventMachine has started or shutdown
              EM.schedule { @started_event.set }
              EM.add_shutdown_hook { @stopped_event.set }

              Jekyll.logger.info "LiveReload address:",
                "http://#{opts["host"]}:#{opts["livereload_port"]}"
            end
          end
          @thread.abort_on_exception = true
        end

        # For a description of the protocol see
        # http://feedback.livereload.com/knowledgebase/articles/86174-livereload-protocol
        def reload(pages)
          pages.each do |p|
            json_message = JSON.dump({
              :command => "reload",
              :path    => p.url,
              :liveCSS => true,
            })

            Jekyll.logger.debug "LiveReload:", "Reloading #{p.url}"
            Jekyll.logger.debug "", json_message
            @websockets.each { |ws| ws.send(json_message) }
          end
        end

        private
        def connect(websocket, handshake)
          @connections_count += 1
          if @connections_count == 1
            message = "Browser connected"
            message += " over SSL/TLS" if handshake.secure?
            Jekyll.logger.info "LiveReload:", message
          end
          websocket.send(
            JSON.dump(
              :command    => "hello",
              :protocols  => ["http://livereload.com/protocols/official-7"],
              :serverName => "jekyll"
            )
          )

          @websockets << websocket
        end

        private
        def disconnect(websocket)
          @websockets.delete(websocket)
        end

        private
        def print_message(json_message)
          msg = JSON.parse(json_message)
          # Not sure what the 'url' command even does in LiveReload.  The spec is silent
          # on its purpose.
          if msg["command"] == "url"
            Jekyll.logger.info "LiveReload:", "Browser URL: #{msg["url"]}"
          end
        end

        private
        def log_error(error)
          Jekyll.logger.error "LiveReload experienced an error. " \
            "Run with --trace for more information."
          raise error
        end
      end
    end
  end
end
