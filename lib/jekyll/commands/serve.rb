# -*- coding: utf-8 -*-
module Jekyll
  module Commands
    class Serve < Command
      def self.process(options)
        s = self.setup_server(options)

        FileUtils.mkdir_p(options['destination'])

        if options['detach'] # detach the server
          pid = Process.fork {s.start}
          Process.detach(pid)
          pid
        else # create a new server thread, then join it with current terminal
          t = Thread.new { s.start }
          trap("INT") { s.shutdown }
          t.join()
        end
      end

      def self.mime_types
        mime_types_file = File.expand_path('../mime.types', File.dirname(__FILE__))
        WEBrick::HTTPUtils::load_mime_types(mime_types_file)
      end

      def self.setup_server(options)
        require 'webrick'
        include WEBrick

        # recreate NondisclosureName under utf-8 circumstance
        fh_option = WEBrick::Config::FileHandler
        fh_option[:NondisclosureName] = ['.ht*','~*']

        server = HTTPServer.new(
          :Port => options['port'],
          :BindAddress => options['host'],
          :MimeTypes => self.mime_types,
          :DoNotReverseLookup => true
        )

        server.mount(options['baseurl'], HTTPServlet::FileHandler, options['destination'], fh_option)
        server
      end
    end
  end
end
