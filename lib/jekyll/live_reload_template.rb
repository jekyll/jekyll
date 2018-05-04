# frozen_string_literal: true

module Jekyll
  class LiveReloadTemplate
    def initialize(options)
      @options = options
    end

    # Generates livereload script tag according to @options
    def template
      # Unclear what "snipver" does. Doc at
      # https://github.com/livereload/livereload-js states that the recommended
      # setting is 1.

      # Complicated JavaScript to ensure that livereload.js is loaded from the
      # same origin as the page.  Mostly useful for dealing with the browser's
      # distinction between 'localhost' and 127.0.0.1
      template = <<-TEMPLATE
      <script>
        document.write(
          '<script src="http://' +
          (location.host || 'localhost').split(':')[0] +
          ':<%=@options["livereload_port"] %>/livereload.js?snipver=1<%= livereload_args %>"' +
          '></' +
          'script>');
      </script>
      TEMPLATE
      ERB.new(Jekyll::Utils.strip_heredoc(template)).result(binding)
    end

    private

    def livereload_args
      # XHTML standard requires ampersands to be encoded as entities when in
      # attributes. See http://stackoverflow.com/a/2190292
      src = ""
      if @options["livereload_min_delay"]
        src += "&amp;mindelay=#{@options["livereload_min_delay"]}"
      end
      if @options["livereload_max_delay"]
        src += "&amp;maxdelay=#{@options["livereload_max_delay"]}"
      end
      if @options["livereload_port"]
        src += "&amp;port=#{@options["livereload_port"]}"
      end
      src
    end
  end
end
