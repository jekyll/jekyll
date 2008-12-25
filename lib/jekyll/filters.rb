module Jekyll
  
  module Filters
    def date_to_string(date, format="%d %b %Y")
      date.strftime(format)
    end

    def date_to_long_string(date)
      date.strftime("%d %B %Y")
    end
    
    def date_to_xmlschema(date)
      date.xmlschema
    end
    
    def xml_escape(input)
      input.gsub("<", "&lt;").gsub(">", "&gt;")
    end
    
    def number_of_words(input)
      input.split.length
    end    
  end  
end