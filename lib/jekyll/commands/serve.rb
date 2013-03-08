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

        s = HTTPServer.new(
          :Port => options['port'],
          :BindAddress => options['host'],
          :MimeTypes => mime_types
        )

        s.mount(options['baseurl'], HTTPServlet::FileHandler, destination)
        t = Thread.new { s.start }
        trap("INT") { s.shutdown }
        t.join()
      end
    end
  end
end
