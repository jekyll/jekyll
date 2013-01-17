module Jekyll

  class ServeCommand < Command
    def self.process(options)
      require 'webrick'
      include WEBrick

      destination = options['destination']

      FileUtils.mkdir_p(destination)

      mime_types = WEBrick::HTTPUtils::DefaultMimeTypes
      mime_types.store 'js', 'application/javascript'

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
