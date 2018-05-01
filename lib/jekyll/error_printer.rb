# frozen_string_literal: true

module Jekyll
  class ErrorPrinter
    def initialize(options)
      @options = options
      @exception = options.fetch("exception")
      @document = options.fetch("document")
      @document_path = @document.path || @document.relative_path
    end

    def call
      ERB.new(error_page).result
    end

    private
    def error_page
      <<-TEMPLATE
      <html>
        #{Jekyll::LiveReloadTemplate.new(@options).template}
        #{error_styles}
        <body>
          <h1>Failed to render.</h1>
          <div>
            #{LiquidRenderer.format_error(@exception, @document_path)}
          </div>
          <code>
            #{file_error_context}
          </code>
          <footer>Edit and save #{@document_path} to reload this page.</footer>
        </body>
      <html>
      TEMPLATE
    end

    private
    def file_error_context(number_of_lines = 7)
      error_lines = []
      @document.content.each_line.with_index do |line, index|
        next if index + 1 < @exception.line_number - number_of_lines / 2
        next if index + 1 > @exception.line_number + number_of_lines / 2

        error_lines << <<-TEMPLATE
          <span class="line #{"error" if @exception.line_number == index + 1}">
            <span class="gutter"></span>
            <span class="lineno">#{index + 1}</span>
            #{line}
            <br />
          </span>
        TEMPLATE
      end
      error_lines.join
    end

    private
    def error_styles
      <<-ERROR_STYLES
      <style type="text/css">
        body { background-color: black; color: rgb(232, 232, 232); font-family: Menlo, Consolas, monospace;
          padding: 2rem; line-height: 1.2; }
        h1 { color: #E36049 }
        div { margin: 20px 0; }
        code { font-size: xx-large; }
        .line.error .gutter::before { content: "⚠️"; width: 0; float:left; }
        .line.error, .line.error .lineno { color: red; }
        .lineno { color: #6D7891; border-right: 1px solid #6D7891; padding-right: 10px; margin: 0 10px 0 5px;
          display: inline-block; text-align: right; width: 3em; }
        footer { border-top: 1px solid #6D7891; margin-top: 5ex; padding-top: 5px; }
      </style>
      ERROR_STYLES
    end
  end
end
