module Jekyll
  module Converters
    class Markdown
      class RDiscountParser
        def initialize(config)
          Jekyll::External.require_with_graceful_fail "rdiscount"
          @config = config
          @rdiscount_extensions = @config['rdiscount']['extensions'].map { |e| e.to_sym }
        end

        def convert(content)
          rd = RDiscount.new(content, *@rdiscount_extensions)
          html = rd.to_html
          if @config['rdiscount']['toc_token']
            html = replace_generated_toc(rd, html, @config['rdiscount']['toc_token'])
          end
          html
        end

        private
        def replace_generated_toc(rd, html, toc_token)
          if rd.generate_toc && html.include?(toc_token)
            utf8_toc = rd.toc_content
            utf8_toc.force_encoding('utf-8') if utf8_toc.respond_to?(:force_encoding)
            html.gsub(toc_token, utf8_toc)
          else
            html
          end
        end
      end
    end
  end
end
