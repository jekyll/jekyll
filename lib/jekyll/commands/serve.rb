# -*- coding: utf-8 -*-
module Jekyll
  module Commands
    class Serve < Command
      def self.process(options)
        require 'webrick'
        include WEBrick

        destination = options['destination']

        FileUtils.mkdir_p(destination)

        mime_types_file = File.expand_path('../mime.types', File.dirname(__FILE__))
        mime_types = WEBrick::HTTPUtils::load_mime_types(mime_types_file)

        # recreate NondisclosureName under utf-8 circumstance
        fh_option = WEBrick::Config::FileHandler
        fh_option[:NondisclosureName] = ['.ht*','~*']

        s = HTTPServer.new(
          :Port => options['port'],
          :BindAddress => options['host'],
          :MimeTypes => mime_types
        )

        s.mount(options['baseurl'], HTTPServlet::FileHandler, destination, fh_option)

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
    end
  end
end
