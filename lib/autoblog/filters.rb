module AutoBlog
  
  module Filters
    def date_to_string(date)
      date.strftime("%d %b %Y")
    end
  end
  
end