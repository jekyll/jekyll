module Jekyll
  module Converters
    class Markdown < Converter
      safe true

      pygments_prefix "\n"
      pygments_suffix "\n"

      def setup
        return if @setup
        @parser = case @config['markdown']
          when 'redcarpet'
            RedcarpetParser.new @config
          when 'kramdown'
            KramdownParser.new @config
          when 'rdiscount'
            RDiscountParser.new @config
          when 'maruku'
            MarukuParser.new @config
          else
            STDERR.puts "Invalid Markdown processor: #{@config['markdown']}"
            STDERR.puts "  Valid options are [ maruku | rdiscount | kramdown ]"
            raise FatalException.new("Invalid Markdown process: #{@config['markdown']}")
        end
        @setup = true
      end

      def matches(ext)
        rgx = '(' + @config['markdown_ext'].gsub(',','|') +')'
        ext =~ Regexp.new(rgx, Regexp::IGNORECASE)
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        setup
        case @config['markdown']
          when 'redcarpet'
            @redcarpet_extensions[:fenced_code_blocks] = !@redcarpet_extensions[:no_fenced_code_blocks]
            @renderer.send :include, Redcarpet::Render::SmartyPants if @redcarpet_extensions[:smart]
            markdown = Redcarpet::Markdown.new(@renderer.new(@redcarpet_extensions), @redcarpet_extensions)
            markdown.render(content)
          when 'kramdown'
            # Check for use of coderay
            if @config['kramdown']['use_coderay']
              Kramdown::Document.new(content, {
                :auto_ids      => @config['kramdown']['auto_ids'],
                :footnote_nr   => @config['kramdown']['footnote_nr'],
                :entity_output => @config['kramdown']['entity_output'],
                :toc_levels    => @config['kramdown']['toc_levels'],
                :smart_quotes  => @config['kramdown']['smart_quotes'],

                :coderay_wrap               => @config['kramdown']['coderay']['coderay_wrap'],
                :coderay_line_numbers       => @config['kramdown']['coderay']['coderay_line_numbers'],
                :coderay_line_number_start  => @config['kramdown']['coderay']['coderay_line_number_start'],
                :coderay_tab_width          => @config['kramdown']['coderay']['coderay_tab_width'],
                :coderay_bold_every         => @config['kramdown']['coderay']['coderay_bold_every'],
                :coderay_css                => @config['kramdown']['coderay']['coderay_css']
              }).to_html
            else
              # not using coderay
              Kramdown::Document.new(content, {
                :auto_ids      => @config['kramdown']['auto_ids'],
                :footnote_nr   => @config['kramdown']['footnote_nr'],
                :entity_output => @config['kramdown']['entity_output'],
                :toc_levels    => @config['kramdown']['toc_levels'],
                :smart_quotes  => @config['kramdown']['smart_quotes']
              }).to_html
            end
          when 'rdiscount'
            rd = RDiscount.new(content, *@rdiscount_extensions)
            html = rd.to_html
            if rd.generate_toc and html.include?(@config['rdiscount']['toc_token'])
              html.gsub!(@config['rdiscount']['toc_token'], rd.toc_content.force_encoding('utf-8'))
            end
            html
          when 'maruku'
            Maruku.new(content).to_html
        end
      end
    end
  end
end
