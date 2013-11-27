module Jekyll
  module Converters
    class Markdown
      class HTMLPipelineParser
        def initialize(config)
          require 'html/pipeline'
          @config = config
          @errors = []
        end

        def filter_key(s)
          s.to_s.downcase.to_sym
        end

        def is_filter?(f)
          f < HTML::Pipeline::Filter
        rescue LoadError, ArgumentError
          false
        end

        def ensure_default_opts
          @config['html_pipeline']['filters'] ||= ['markdownfilter']
          @config['html_pipeline']['context'] ||= {'gfm' => true}
          # symbolize strings as keys, which is what HTML::Pipeline wants
          @config['html_pipeline']['context'] = @config['html_pipeline']['context'].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        end

        def setup
          unless @setup
            ensure_default_opts

            filters = @config['html_pipeline']['filters'].map do |f|
              if is_filter?(f)
                f
              else
                key = filter_key(f)
                begin
                  filter = HTML::Pipeline.constants.find { |c| c.downcase == key }
                  HTML::Pipeline.const_get(filter)
                rescue Exception => e
                  raise FatalException.new(e)
                end
              end
            end

            @parser = HTML::Pipeline.new(filters, @config['html_pipeline']['context'])
            @setup = true
          end
        end

        def convert(content)
          setup
          @parser.to_html(content)
        end
      end
    end
  end
end
