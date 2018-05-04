# frozen_string_literal: true

require "helper"

class TestErrorPrinter < JekyllUnitTest
  context "rendering error page" do
    setup do
      site = fixture_site("collections" => ["liquid_broken"])
      begin
        site.process
      rescue Liquid::SyntaxError => e
        @exception = e
        @document = Document.new(
          site.in_source_dir(File.join("_liquid_broken", "liquid_error.md")),
          {
            :site       => site,
            :collection => site.collections["liquid_broken"],
          }
        ).tap(&:read)
        @document_path = @document.path || @document.relative_path
      end
    end

    subject do
      ErrorPrinter.new(
        "livereload_port" => 35_729,
        "exception"       => @exception,
        "document"        => @document
      )
    end

    should "return correct html page" do
      error_page = subject.call

      assert_match(
        "Liquid syntax error (line 5): Unknown tag 'syntaxerrorgoeshere'",
        error_page
      )
      assert_match(@document_path, error_page)

      error_template = <<-ERROR_TEMPLATE
        <span class="line ">
          <span class="gutter"></span>
          <span class="lineno">3</span>
          This is a markdown with a Liquid Syntax Error.
        ERROR_TEMPLATE

      assert_match(error_template.delete(" "), error_page.delete(" "))
      assert_match("Edit and save #{@document_path} to reload this page", error_page)
    end
  end
end
