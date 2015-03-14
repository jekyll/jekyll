require 'redcarpet'

module Jekyll
  module Converters
    class Smartypants
      class RedcarpetParser
        def convert(content)
          Redcarpet::Render::SmartyPants.render(content)
        end
      end
    end
  end
end
