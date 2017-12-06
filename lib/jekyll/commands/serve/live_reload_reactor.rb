# frozen_string_literal: true

require "json"
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
          @thread = nil
          @websockets = []
          @connections_count = 0
          @started_event = Utils::ThreadEvent.new
          @stopped_event = Utils::ThreadEvent.new
        end

        def stop
          # There is only one EventMachine instance per Ruby process so stopping
          # it here will stop the reactor thread we have running.
          EM.stop if EM.reactor_running?
          Jekyll.logger.debug("LiveReload Server:", "halted")
        end

        def running?
          EM.reactor_running?
        end

        def handle_websockets_event(ws)
          ws.onopen do |handshake|
            connect(ws, handshake)
          end

          ws.onclose do
            disconnect(ws)
          end

          ws.onmessage do |msg|
            print_message(msg)
          end

          ws.onerror do |error|
            log_error(error)
          end
        end

        # rubocop:disable Metrics/MethodLength
        def start(opts)
          @thread = Thread.new do
            # Use epoll if the kernel supports it
            EM.epoll
            EM.run do
              EM.error_handler do |e|
                log_error(e)
              end

              EM.start_server(
                opts["host"],
                opts["livereload_port"],
                HttpAwareConnection,
                opts
              ) do |ws|
                handle_websockets_event(ws)
              end

              # Notify blocked threads that EventMachine has started or shutdown
              EM.schedule do
                @started_event.set
              end

              EM.add_shutdown_hook do
                @stopped_event.set
              end

              Jekyll.logger.info(
                "LiveReload address:", "#{opts["host"]}:#{opts["livereload_port"]}"
              )
            end
          end
          @thread.abort_on_exception = true
        end

        # For a description of the protocol see
        # http://feedback.livereload.com/knowledgebase/articles/86174-livereload-protocol
        def reload(pages)
          pages.each do |p|
            msg = {
              :command => "reload",
              :path    => p.url,
              :liveCSS => true,
            }

            Jekyll.logger.debug("LiveReload:", "Reloading #{p.url}")
            Jekyll.logger.debug(JSON.dump(msg))
            @websockets.each do |ws|
              ws.send(JSON.dump(msg))
            end
          end
        end

        private
        def connect(ws, handshake)
          @connections_count += 1
          if @connections_count == 1
            message = "Browser connected"
            message += " over SSL/TLS" if handshake.secure?
            Jekyll.logger.info("LiveReload:", message)
          end
          ws.send(
            JSON.dump(
              :command    => "hello",
              :protocols  => ["http://livereload.com/protocols/official-7"],
              :serverName => "jekyll"
            )
          )

          @websockets << ws
        end

        private
        def disconnect(ws)
          @websockets.delete(ws)
        end

        private
        def print_message(json_message)
          msg = JSON.parse(json_message)
          # Not sure what the 'url' command even does in LiveReload.  The spec is silent
          # on its purpose.
          if msg["command"] == "url"
            Jekyll.logger.info("LiveReload:", "Browser URL: #{msg["url"]}")
          end
        end

        private
        def log_error(e)
          Jekyll.logger.warn(
            "LiveReload experienced an error. "\
            "Run with --verbose for more information."
          )
          Jekyll.logger.debug("LiveReload Error:", e.message)
          Jekyll.logger.debug("LiveReload Error:", e.backtrace.join("\n"))
        end
      end
    end
  end
end
